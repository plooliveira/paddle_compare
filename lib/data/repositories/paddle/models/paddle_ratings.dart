import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_readers.dart';

part 'paddle_ratings.freezed.dart';

@freezed
abstract class PaddleRatings with _$PaddleRatings {
  const factory PaddleRatings({int? power, int? control, int? spin, int? pop}) =
      _PaddleRatings;

  static PaddleRatings fromJsonOrEmpty(Object? json) {
    final map = readMap(json);
    if (map == null) return const PaddleRatings();
    return PaddleRatings(
      power: _readRating(map['power']),
      control: _readRating(map['control']),
      spin: _readRating(map['spin']),
      pop: _readRating(map['pop']),
    );
  }
}

int? _readRating(Object? value) {
  final rating = readInt(value);
  return rating != null && rating >= 0 && rating <= 10 ? rating : null;
}
