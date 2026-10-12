import '../../../core/utils/result.dart';
import 'models/paddle.dart';
import 'models/paddle_query.dart';

export 'models/paddle.dart';
export 'models/paddle_dimensions.dart';
export 'models/paddle_query.dart';
export 'models/paddle_ratings.dart';
export 'models/paddle_shape.dart';
export 'models/paddle_sort.dart';
export 'paddle_repository_exception.dart';

abstract interface class PaddleRepository {
  /// The paddles matching [query], in its sort order, starting at [offset].
  ///
  /// The order is stable across pages: requesting consecutive pages of the
  /// same query gives the whole result once, with no overlaps or gaps.
  Future<Result<List<Paddle>>> getPaddles({
    PaddleQuery query = const PaddleQuery(),
    int offset = 0,
    int? limit,
  });

  Future<Result<Paddle?>> getPaddleById(String id);
}
