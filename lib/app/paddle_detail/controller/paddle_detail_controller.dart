import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../data/repositories/paddle/paddle_repository.dart';
import '../../../data/repositories/paddle/paddle_repository_provider.dart';

part 'paddle_detail_controller.g.dart';

/// The paddle id in the detail URL. PaddleDetailView overrides it for its
/// subtree.
@Riverpod(dependencies: [])
String paddleDetailId(Ref ref) => throw UnimplementedError();

Duration? _noRetry(int retryCount, Object error) => null;

/// The paddle whose id is in the URL, or null when there is no such paddle.
@Riverpod(retry: _noRetry, dependencies: [paddleDetailId])
class PaddleDetailController extends _$PaddleDetailController {
  @override
  Future<Paddle?> build() async {
    final id = ref.watch(paddleDetailIdProvider);
    final result = await ref.watch(paddleRepositoryProvider).getPaddleById(id);
    return switch (result) {
      Ok(:final value) => value,
      Error(:final error) => throw error,
    };
  }

  /// Loads the paddle again after a failure.
  void retry() => ref.invalidateSelf();
}
