import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/app/compare/controller/compare_controller.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import '../../../helpers/fake_paddle_repository.dart';

const _a = Paddle(id: 'a', brand: 'Brand', name: 'Paddle A');
const _b = Paddle(id: 'b', brand: 'Brand', name: 'Paddle B');

void main() {
  late FakePaddleRepository repository;
  late ProviderContainer container;

  void listen(String id) =>
      // Keeps the auto-dispose controller alive between reads.
      container.listen(comparePaddleControllerProvider(id), (_, _) {});
  AsyncValue<Paddle?> state(String id) =>
      container.read(comparePaddleControllerProvider(id));
  Future<Paddle?> loaded(String id) =>
      container.read(comparePaddleControllerProvider(id).future);

  setUp(() {
    repository = FakePaddleRepository([_a, _b]);
    container = ProviderContainer.test(
      overrides: [paddleRepositoryProvider.overrideWithValue(repository)],
    );
  });

  test('loads the paddle with its id', () async {
    listen('b');

    expect(await loaded('b'), _b);
    expect(repository.ids, ['b']);
  });

  test('is null for an unknown id', () async {
    listen('nope');

    expect(await loaded('nope'), isNull);
    expect(state('nope'), isA<AsyncData<Paddle?>>());
  });

  test('a failure is an AsyncError and is not retried automatically', () {
    fakeAsync((async) {
      const exception = PaddleRepositoryException('down');
      repository.error = exception;
      listen('a');

      async.flushMicrotasks();
      final value = state('a');
      expect(value, isA<AsyncError<Paddle?>>());
      expect(value.error, exception);
      expect(value.retrying, isFalse);

      async.elapse(const Duration(minutes: 1));
      expect(repository.ids, ['a']);
    });
  });

  test('retry loads again after a failure', () async {
    repository.error = const PaddleRepositoryException('down');
    listen('a');
    await expectLater(loaded('a'), throwsA(isA<PaddleRepositoryException>()));

    repository.error = null;
    container.read(comparePaddleControllerProvider('a').notifier).retry();

    expect(await loaded('a'), _a);
    expect(repository.ids, ['a', 'a']);
  });

  test('each id loads on its own', () async {
    listen('a');
    listen('nope');

    expect(await loaded('a'), _a);
    expect(await loaded('nope'), isNull);

    // A new paddle next to a loaded one fetches only the new one.
    listen('b');

    expect(await loaded('b'), _b);
    expect(repository.ids, ['a', 'nope', 'b']);
  });
}
