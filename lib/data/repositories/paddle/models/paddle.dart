import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_readers.dart';
import 'paddle_dimensions.dart';
import 'paddle_ratings.dart';
import 'paddle_shape.dart';

part 'paddle.freezed.dart';

const _gramsPerOunce = 28.349523125;

@freezed
abstract class Paddle with _$Paddle {
  const factory Paddle({
    required String id,
    required String brand,
    required String name,
    int? releaseYear,
    double? priceUsd,
    bool? inStock,
    PaddleShape? shape,
    String? faceMaterial,
    double? coreThicknessMm,
    // Always in ounces, whatever unit the API reported.
    double? weightOz,
    double? swingWeight,
    double? twistWeight,
    @Default(PaddleDimensions()) PaddleDimensions dimensions,
    double? gripCircumferenceIn,
    @Default(PaddleRatings()) PaddleRatings ratings,
    String? imagePath,
    String? description,
  }) = _Paddle;

  /// Returns null when [json] is not an object or lacks an id, brand or name.
  static Paddle? tryFromJson(Object? json) {
    final map = readMap(json);
    if (map == null) return null;

    final id = readString(map['id']);
    final brand = readString(map['brand']);
    final name = readString(map['name']);
    if (id == null || brand == null || name == null) return null;

    return Paddle(
      id: id,
      brand: brand,
      name: name,
      releaseYear: readInt(map['releaseYear']),
      priceUsd: _positive(readDouble(map['priceUsd'])),
      inStock: readBool(map['inStock']),
      shape: PaddleShape.tryParse(map['shape']),
      faceMaterial: readString(map['faceMaterial']),
      coreThicknessMm: _positive(readDouble(map['coreThicknessMm'])),
      weightOz: _readWeightOz(map['weight']),
      swingWeight: _positive(readDouble(map['swingWeight'])),
      twistWeight: _positive(readDouble(map['twistWeight'])),
      dimensions: PaddleDimensions.fromJsonOrEmpty(map['dimensionsIn']),
      gripCircumferenceIn: _positive(readDouble(map['gripCircumferenceIn'])),
      ratings: PaddleRatings.fromJsonOrEmpty(map['ratings']),
      imagePath: readString(map['imagePath']),
      description: readString(map['description']),
    );
  }
}

double? _positive(double? value) => value != null && value > 0 ? value : null;

double? _readWeightOz(Object? json) {
  final map = readMap(json);
  if (map == null) return null;
  final value = _positive(readDouble(map['value']));
  if (value == null) return null;
  return switch (readString(map['unit'])?.toLowerCase()) {
    'oz' || 'ounce' || 'ounces' => value,
    'g' || 'gram' || 'grams' => value / _gramsPerOunce,
    _ => null,
  };
}
