import '../../../core/utils/result.dart';
import '../../api/paddle_api.dart';
import 'paddle_repository.dart';

class PaddleRepositoryFromFake implements PaddleRepository {
  PaddleRepositoryFromFake(this._api);

  final PaddleApi _api;

  @override
  Future<Result<List<Paddle>>> getPaddles() async {
    try {
      final json = await _api.fetchPaddles();
      final items = json['paddles'];
      if (items is! List) {
        return const Result.error(
          PaddleRepositoryException('Unexpected response shape'),
        );
      }

      final paddlesById = <String, Paddle>{};
      for (final item in items) {
        final paddle = Paddle.tryFromJson(item);
        if (paddle != null) paddlesById.putIfAbsent(paddle.id, () => paddle);
      }
      return Result.ok(List.unmodifiable(paddlesById.values));
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }

  @override
  Future<Result<Paddle?>> getPaddleById(String id) async {
    final result = await getPaddles();
    switch (result) {
      case Ok<List<Paddle>>():
        return Result.ok(
          result.value.where((paddle) => paddle.id == id).firstOrNull,
        );
      case Error<List<Paddle>>():
        return Result.error(result.error);
    }
  }
}
