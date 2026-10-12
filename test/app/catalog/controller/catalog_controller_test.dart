import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/app/catalog/controller/catalog_controller.dart';
import 'package:paddle_compare/app/catalog/controller/catalog_filter.dart';
import 'package:paddle_compare/app/catalog/state/catalog_state.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import '../../../helpers/fake_paddle_repository.dart';

/// Even indexes are standard, odd ones hybrid. Prices go up with the index.
List<Paddle> _paddles(int count) => [
  for (var i = 0; i < count; i++)
    Paddle(
      id: 'p$i',
      brand: 'Brand',
      name: 'Paddle $i',
      priceUsd: 100.0 + i,
      inStock: i % 3 != 0,
      shape: i.isEven ? PaddleShape.standard : PaddleShape.hybrid,
    ),
];

List<String> _ids(List<Paddle> paddles) => [
  for (final paddle in paddles) paddle.id,
];

final _hybrid = CatalogFilter(shapes: {PaddleShape.hybrid});

List<Override> _overrides(
  FakePaddleRepository repository,
  CatalogFilter filter,
) => [
  paddleRepositoryProvider.overrideWithValue(repository),
  catalogFilterProvider.overrideWithValue(filter),
];

ProviderContainer _container(
  FakePaddleRepository repository, [
  CatalogFilter filter = const CatalogFilter(),
]) {
  final container = ProviderContainer.test(
    overrides: _overrides(repository, filter),
  );
  // Keeps the auto-dispose controller alive between reads.
  container.listen(catalogControllerProvider, (_, _) {});
  return container;
}

const _pageSize = CatalogController.pageSize;

void main() {
  late FakePaddleRepository repository;
  late ProviderContainer container;

  CatalogController controller() =>
      container.read(catalogControllerProvider.notifier);
  AsyncValue<CatalogState> state() => container.read(catalogControllerProvider);
  CatalogState current() => state().value!;
  Future<CatalogState> loaded() =>
      container.read(catalogControllerProvider.future);

  /// Stands in for a navigation to a new catalog URL.
  void setFilter(CatalogFilter filter) =>
      container.updateOverrides(_overrides(repository, filter));

  group('initial load', () {
    test('loads the first page for the filter in the URL', () async {
      repository = FakePaddleRepository(_paddles(30));
      container = _container(repository, _hybrid);

      final state = await loaded();

      expect(_ids(state.paddles), [for (var i = 1; i < 24; i += 2) 'p$i']);
      expect(state.query, _hybrid.toQuery());
      expect(state.hasMore, isTrue);
      expect(state.isLoadingMore, isFalse);
      expect(state.loadMoreError, isNull);
      expect(repository.offsets, [0]);
      expect(repository.queries, [_hybrid.toQuery()]);
    });

    test('has no more pages when the first page is short', () async {
      repository = FakePaddleRepository(_paddles(5));
      container = _container(repository);

      final state = await loaded();

      expect(state.paddles, hasLength(5));
      expect(state.hasMore, isFalse);
    });

    test('a failure is an AsyncError and is not retried automatically', () {
      fakeAsync((async) {
        const exception = PaddleRepositoryException('down');
        repository = FakePaddleRepository(_paddles(30))..error = exception;
        container = _container(repository);

        async.flushMicrotasks();
        final value = state();
        expect(value, isA<AsyncError<CatalogState>>());
        expect(value.error, exception);
        expect(value.retrying, isFalse);

        async.elapse(const Duration(minutes: 1));
        expect(repository.offsets, [0]);
      });
    });

    test('retry reloads after a failure', () async {
      repository = FakePaddleRepository(_paddles(30))
        ..error = const PaddleRepositoryException('down');
      container = _container(repository);
      await expectLater(loaded(), throwsA(isA<PaddleRepositoryException>()));

      repository.error = null;
      controller().retry();

      expect((await loaded()).paddles, hasLength(_pageSize));
      expect(repository.offsets, [0, 0]);
    });
  });

  group('loadMore', () {
    setUp(() async {
      repository = FakePaddleRepository(_paddles(30));
      container = _container(repository);
      await loaded();
    });

    test('appends pages until a short one arrives', () async {
      await controller().loadMore();
      expect(current().paddles, hasLength(24));
      expect(current().hasMore, isTrue);

      await controller().loadMore();
      expect(current().paddles, hasLength(30));
      expect(current().hasMore, isFalse);
      expect(_ids(current().paddles), _ids(_paddles(30)));

      await controller().loadMore();
      expect(repository.offsets, [0, 12, 24]);
    });

    test('flags the page in flight and ignores concurrent calls', () async {
      repository.gate = Completer<void>();

      final first = controller().loadMore();
      expect(current().isLoadingMore, isTrue);
      await controller().loadMore();

      repository.gate!.complete();
      await first;

      expect(repository.offsets, [0, 12]);
      expect(current().isLoadingMore, isFalse);
      expect(current().paddles, hasLength(24));
    });

    test(
      'a failure keeps the loaded pages, and calling again retries',
      () async {
        const exception = PaddleRepositoryException('down');
        repository.error = exception;

        await controller().loadMore();

        expect(state().hasValue, isTrue);
        expect(current().paddles, hasLength(_pageSize));
        expect(current().loadMoreError, exception);
        expect(current().isLoadingMore, isFalse);
        expect(current().hasMore, isTrue);

        repository.error = null;
        await controller().loadMore();

        expect(current().paddles, hasLength(24));
        expect(current().loadMoreError, isNull);
      },
    );

    test('drops a page that arrives after a retry', () async {
      final slowPage = Completer<void>();
      repository.gate = slowPage;
      final stale = controller().loadMore();

      repository.gate = null;
      controller().retry();
      await loaded();
      slowPage.complete();
      await stale;

      expect(current().paddles, hasLength(_pageSize));
      expect(current().isLoadingMore, isFalse);
    });
  });

  group('loadMore with a query', () {
    test('sends the current query', () async {
      repository = FakePaddleRepository(_paddles(30));
      container = _container(repository, _hybrid);
      await loaded();

      await controller().loadMore();

      expect(repository.offsets, [0, 12]);
      expect(repository.queries, [_hybrid.toQuery(), _hybrid.toQuery()]);
      expect(_ids(current().paddles), [for (var i = 1; i < 30; i += 2) 'p$i']);
      expect(current().hasMore, isFalse);
    });

    test('sorted pages keep the order across the whole catalog', () async {
      repository = FakePaddleRepository(_paddles(30));
      container = _container(
        repository,
        const CatalogFilter(sort: PaddleSort.priceHighToLow),
      );
      await loaded();

      await controller().loadMore();
      await controller().loadMore();

      expect(_ids(current().paddles), [for (var i = 29; i >= 0; i--) 'p$i']);
    });
  });

  group('filter change', () {
    setUp(() async {
      repository = FakePaddleRepository(_paddles(30));
      container = _container(repository);
      await loaded();
      await controller().loadMore();
    });

    test(
      'reloads from offset 0 with the new query, keeping the old results',
      () async {
        repository.gate = Completer<void>();

        setFilter(_hybrid);

        final reloading = state();
        expect(reloading, isA<AsyncLoading<CatalogState>>());
        expect(reloading.value?.query, const PaddleQuery());
        expect(reloading.value?.paddles, hasLength(24));

        repository.gate!.complete();
        final reloaded = await loaded();

        expect(repository.offsets, [0, 12, 0]);
        expect(repository.queries.last, _hybrid.toQuery());
        expect(reloaded.query, _hybrid.toQuery());
        expect(_ids(reloaded.paddles), [for (var i = 1; i < 24; i += 2) 'p$i']);
        expect(reloaded.hasMore, isTrue);
      },
    );

    test('a search that only adds spaces does not reload', () async {
      setFilter(const CatalogFilter(query: 'paddle 1'));
      await loaded();
      final requests = repository.queries.length;

      setFilter(const CatalogFilter(query: ' paddle 1  '));

      expect(state(), isA<AsyncData<CatalogState>>());
      expect(repository.queries, hasLength(requests));
    });

    test('drops the response for the previous filter', () async {
      final slowResponse = Completer<void>();
      repository.gate = slowResponse;
      setFilter(_hybrid);
      state();

      repository.gate = null;
      setFilter(const CatalogFilter(sort: PaddleSort.priceHighToLow));
      final reloaded = await loaded();
      slowResponse.complete();
      await Future<void>.delayed(Duration.zero);

      expect(current(), reloaded);
      expect(current().query.sort, PaddleSort.priceHighToLow);
    });

    test('drops a page in flight', () async {
      final slowPage = Completer<void>();
      repository.gate = slowPage;
      final stale = controller().loadMore();

      repository.gate = null;
      setFilter(_hybrid);
      await loaded();
      slowPage.complete();
      await stale;

      expect(current().query, _hybrid.toQuery());
      expect(_ids(current().paddles), [for (var i = 1; i < 24; i += 2) 'p$i']);
      expect(current().isLoadingMore, isFalse);
    });

    test('a failure is an AsyncError', () async {
      const exception = PaddleRepositoryException('down');
      repository.error = exception;

      setFilter(_hybrid);

      await expectLater(loaded(), throwsA(exception));
      expect(state(), isA<AsyncError<CatalogState>>());
    });
  });
}
