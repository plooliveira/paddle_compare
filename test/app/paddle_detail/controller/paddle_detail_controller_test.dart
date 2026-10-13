import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/app/paddle_detail/controller/paddle_detail_controller.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import '../../../helpers/fake_paddle_repository.dart';

const _a = Paddle(id: 'a', brand: 'Brand', name: 'Paddle A');
const _b = Paddle(id: 'b', brand: 'Brand', name: 'Paddle B');

List<Override> _overrides(FakePaddleRepository repository, String id) => [
  paddleRepositoryProvider.overrideWithValue(repository),
  paddleDetailIdProvider.overrideWithValue(id),
];

ProviderContainer _container(FakePaddleRepository repository, String id) {
  final container = ProviderContainer.test(
    overrides: _overrides(repository, id),
  );
  // Keeps the auto-dispose controller alive between reads.
  container.listen(paddleDetailControllerProvider, (_, _) {});
  return container;
}

void main() {
  late FakePaddleRepository repository;
  late ProviderContainer container;

  AsyncValue<Paddle?> state() => container.read(paddleDetailControllerProvider);
  Future<Paddle?> loaded() =>
      container.read(paddleDetailControllerProvider.future);

  setUp(() => repository = FakePaddleRepository([_a, _b]));

  test('loads the paddle with the id in the URL', () async {
    container = _container(repository, 'b');

    expect(await loaded(), _b);
    expect(repository.ids, ['b']);
  });

  test('is null for an unknown id', () async {
    container = _container(repository, 'nope');

    expect(await loaded(), isNull);
    expect(state(), isA<AsyncData<Paddle?>>());
  });

  test('a failure is an AsyncError and is not retried automatically', () {
    fakeAsync((async) {
      const exception = PaddleRepositoryException('down');
      repository.error = exception;
      container = _container(repository, 'a');

      async.flushMicrotasks();
      final value = state();
      expect(value, isA<AsyncError<Paddle?>>());
      expect(value.error, exception);
      expect(value.retrying, isFalse);

      async.elapse(const Duration(minutes: 1));
      expect(repository.ids, ['a']);
    });
  });

  test('retry loads again after a failure', () async {
    repository.error = const PaddleRepositoryException('down');
    container = _container(repository, 'a');
    await expectLater(loaded(), throwsA(isA<PaddleRepositoryException>()));

    repository.error = null;
    container.read(paddleDetailControllerProvider.notifier).retry();

    expect(await loaded(), _a);
    expect(repository.ids, ['a', 'a']);
  });

  test('a new id in the URL loads that paddle', () async {
    container = _container(repository, 'a');
    expect(await loaded(), _a);

    container.updateOverrides(_overrides(repository, 'b'));

    expect(await loaded(), _b);
    expect(repository.ids, ['a', 'b']);
  });
}
