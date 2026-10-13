import '../../../core/utils/result.dart';
import '../../api/paddle_api.dart';
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
      final json = await _api.fetchPaddles(
        search: query.search,
        shapes: [for (final shape in query.shapes) shape.name],
        minPrice: query.minPrice,
        maxPrice: query.maxPrice,
        inStockOnly: query.inStockOnly,
        sort: switch (query.sort) {
          PaddleSort.featured => null,
          PaddleSort.priceLowToHigh => PaddleApi.sortPriceAsc,
          PaddleSort.priceHighToLow => PaddleApi.sortPriceDesc,
          PaddleSort.power => PaddleApi.sortPower,
        },
        offset: offset,
        limit: limit,
      );
      final items = json['paddles'];
      if (items is! List) {
        return const Result.error(
          PaddleRepositoryException('Unexpected response shape'),
        );
      }
      return Result.ok(
        List.unmodifiable([
          for (final item in items) ?Paddle.tryFromJson(item),
        ]),
      );
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }

  @override
  Future<Result<Paddle?>> getPaddleById(String id) async {
    try {
      final json = await _api.fetchPaddle(id);
      return Result.ok(json == null ? null : Paddle.tryFromJson(json));
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }
}
