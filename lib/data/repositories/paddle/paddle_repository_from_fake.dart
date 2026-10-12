import '../../../core/utils/result.dart';
import '../../api/paddle_api.dart';
import 'paddle_query_in_memory.dart';
import 'paddle_repository.dart';

class PaddleRepositoryFromFake implements PaddleRepository {
  PaddleRepositoryFromFake(this._api);

  final PaddleApi _api;

  @override
  Future<Result<List<Paddle>>> getPaddles({
    PaddleQuery query = const PaddleQuery(),
    int offset = 0,
    int? limit,
  }) async {
    assert(offset >= 0 && (limit == null || limit >= 0));
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
      // This is where the fake stands in for the server: the API returns the
      // whole catalog, so the query runs here, after deduplication, and the
      // page is sliced from the result. An HTTP implementation would turn
      // the query into request parameters instead.
      final page = query.apply(paddlesById.values).skip(offset);
      return Result.ok(
        List.unmodifiable(limit == null ? page : page.take(limit)),
      );
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
