import 'json_readers.dart';

enum PaddleShape {
  standard,
  hybrid,
  elongated,
  widebody;

  static PaddleShape? tryParse(Object? value) {
    final normalized = readString(value)
        ?.toLowerCase()
        .replaceAll(RegExp(r'[\s_-]'), '');
    for (final shape in values) {
      if (shape.name == normalized) return shape;
    }
    return null;
  }
}
