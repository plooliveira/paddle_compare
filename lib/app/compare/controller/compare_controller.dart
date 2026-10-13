import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../data/repositories/paddle/paddle_repository.dart';
import '../../../data/repositories/paddle/paddle_repository_provider.dart';

part 'compare_controller.g.dart';

/// The paddle ids in the compare URL, in order. CompareView overrides it for
/// its subtree.
@Riverpod(dependencies: [])
List<String> compareIds(Ref ref) => throw UnimplementedError();

Duration? _noRetry(int retryCount, Object error) => null;

/// One paddle of the comparison, or null when there is no such paddle.
///
/// One per id, so each column loads, fails and retries on its own, and a new
/// id in the URL only loads that paddle.
@Riverpod(retry: _noRetry)
class ComparePaddleController extends _$ComparePaddleController {
  @override
  Future<Paddle?> build(String id) async {
    final result = await ref.watch(paddleRepositoryProvider).getPaddleById(id);
    return switch (result) {
      Ok(:final value) => value,
      Error(:final error) => throw error,
    };
  }

  /// Loads the paddle again after a failure.
  void retry() => ref.invalidateSelf();
}
