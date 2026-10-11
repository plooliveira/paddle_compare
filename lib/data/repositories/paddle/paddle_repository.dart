import '../../../core/utils/result.dart';
import 'models/paddle.dart';

export 'models/paddle.dart';
export 'models/paddle_dimensions.dart';
export 'models/paddle_ratings.dart';
export 'models/paddle_shape.dart';
export 'paddle_repository_exception.dart';

abstract interface class PaddleRepository {
  Future<Result<List<Paddle>>> getPaddles();

  Future<Result<Paddle?>> getPaddleById(String id);
}
