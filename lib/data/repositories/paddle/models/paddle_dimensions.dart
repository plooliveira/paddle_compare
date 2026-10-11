import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_readers.dart';

part 'paddle_dimensions.freezed.dart';

@freezed
abstract class PaddleDimensions with _$PaddleDimensions {
  const factory PaddleDimensions({
    double? lengthIn,
    double? widthIn,
    double? handleLengthIn,
  }) = _PaddleDimensions;

  static PaddleDimensions fromJsonOrEmpty(Object? json) {
    final map = readMap(json);
    if (map == null) return const PaddleDimensions();
    return PaddleDimensions(
      lengthIn: _readLength(map['length']),
      widthIn: _readLength(map['width']),
      handleLengthIn: _readLength(map['handleLength']),
    );
  }
}

double? _readLength(Object? value) {
  final length = readDouble(value);
  return length != null && length > 0 ? length : null;
}
