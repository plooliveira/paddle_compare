// Tolerant readers for dirty JSON: anything unexpected becomes null.

Map<String, Object?>? readMap(Object? value) =>
    value is Map<String, Object?> ? value : null;

String? readString(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

double? readDouble(Object? value) {
  final number = switch (value) {
    num() => value.toDouble(),
    String() => double.tryParse(value.trim()),
    _ => null,
  };
  return number != null && number.isFinite ? number : null;
}

int? readInt(Object? value) => readDouble(value)?.round();

bool? readBool(Object? value) => switch (value) {
  bool() => value,
  'true' => true,
  'false' => false,
  _ => null,
};
