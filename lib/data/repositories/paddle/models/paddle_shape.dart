import '../../../../core/utils/json_readers.dart';

enum PaddleShape {
  standard,
  hybrid,
  elongated,
  widebody;

  static PaddleShape? tryParse(Object? value) {
    final token = readToken(value);
    for (final shape in values) {
      if (shape.name == token) return shape;
    }
    return null;
  }
}
