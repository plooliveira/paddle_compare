// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paddle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Paddle {

 String get id; String get brand; String get name; int? get releaseYear; double? get priceUsd; bool? get inStock; PaddleShape? get shape; String? get faceMaterial; double? get coreThicknessMm; double? get weightOz; double? get swingWeight; double? get twistWeight; PaddleDimensions get dimensions; double? get gripCircumferenceIn; PaddleRatings get ratings; String? get imagePath; String? get description;
/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaddleCopyWith<Paddle> get copyWith => _$PaddleCopyWithImpl<Paddle>(this as Paddle, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Paddle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Paddle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.releaseYear, _this.releaseYear) || other.releaseYear == _this.releaseYear)&&(identical(other.priceUsd, _this.priceUsd) || other.priceUsd == _this.priceUsd)&&(identical(other.inStock, _this.inStock) || other.inStock == _this.inStock)&&(identical(other.shape, _this.shape) || other.shape == _this.shape)&&(identical(other.faceMaterial, _this.faceMaterial) || other.faceMaterial == _this.faceMaterial)&&(identical(other.coreThicknessMm, _this.coreThicknessMm) || other.coreThicknessMm == _this.coreThicknessMm)&&(identical(other.weightOz, _this.weightOz) || other.weightOz == _this.weightOz)&&(identical(other.swingWeight, _this.swingWeight) || other.swingWeight == _this.swingWeight)&&(identical(other.twistWeight, _this.twistWeight) || other.twistWeight == _this.twistWeight)&&(identical(other.dimensions, _this.dimensions) || other.dimensions == _this.dimensions)&&(identical(other.gripCircumferenceIn, _this.gripCircumferenceIn) || other.gripCircumferenceIn == _this.gripCircumferenceIn)&&(identical(other.ratings, _this.ratings) || other.ratings == _this.ratings)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.description, _this.description) || other.description == _this.description));
}


@override
int get hashCode {
  final _this = this as Paddle;
  return Object.hash(runtimeType,_this.id,_this.brand,_this.name,_this.releaseYear,_this.priceUsd,_this.inStock,_this.shape,_this.faceMaterial,_this.coreThicknessMm,_this.weightOz,_this.swingWeight,_this.twistWeight,_this.dimensions,_this.gripCircumferenceIn,_this.ratings,_this.imagePath,_this.description);
}

@override
String toString() {
  final _this = this as Paddle;
  return 'Paddle(id: ${_this.id}, brand: ${_this.brand}, name: ${_this.name}, releaseYear: ${_this.releaseYear}, priceUsd: ${_this.priceUsd}, inStock: ${_this.inStock}, shape: ${_this.shape}, faceMaterial: ${_this.faceMaterial}, coreThicknessMm: ${_this.coreThicknessMm}, weightOz: ${_this.weightOz}, swingWeight: ${_this.swingWeight}, twistWeight: ${_this.twistWeight}, dimensions: ${_this.dimensions}, gripCircumferenceIn: ${_this.gripCircumferenceIn}, ratings: ${_this.ratings}, imagePath: ${_this.imagePath}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $PaddleCopyWith<$Res>  {
  factory $PaddleCopyWith(Paddle value, $Res Function(Paddle) _then) = _$PaddleCopyWithImpl;
@useResult
$Res call({
 String id, String brand, String name, int? releaseYear, double? priceUsd, bool? inStock, PaddleShape? shape, String? faceMaterial, double? coreThicknessMm, double? weightOz, double? swingWeight, double? twistWeight, PaddleDimensions dimensions, double? gripCircumferenceIn, PaddleRatings ratings, String? imagePath, String? description
});


$PaddleDimensionsCopyWith<$Res> get dimensions;$PaddleRatingsCopyWith<$Res> get ratings;

}
/// @nodoc
class _$PaddleCopyWithImpl<$Res>
    implements $PaddleCopyWith<$Res> {
  _$PaddleCopyWithImpl(this._self, this._then);

  final Paddle _self;
  final $Res Function(Paddle) _then;

/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brand = null,Object? name = null,Object? releaseYear = freezed,Object? priceUsd = freezed,Object? inStock = freezed,Object? shape = freezed,Object? faceMaterial = freezed,Object? coreThicknessMm = freezed,Object? weightOz = freezed,Object? swingWeight = freezed,Object? twistWeight = freezed,Object? dimensions = null,Object? gripCircumferenceIn = freezed,Object? ratings = null,Object? imagePath = freezed,Object? description = freezed,}) {
  return _then(Paddle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,priceUsd: freezed == priceUsd ? _self.priceUsd : priceUsd // ignore: cast_nullable_to_non_nullable
as double?,inStock: freezed == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as bool?,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as PaddleShape?,faceMaterial: freezed == faceMaterial ? _self.faceMaterial : faceMaterial // ignore: cast_nullable_to_non_nullable
as String?,coreThicknessMm: freezed == coreThicknessMm ? _self.coreThicknessMm : coreThicknessMm // ignore: cast_nullable_to_non_nullable
as double?,weightOz: freezed == weightOz ? _self.weightOz : weightOz // ignore: cast_nullable_to_non_nullable
as double?,swingWeight: freezed == swingWeight ? _self.swingWeight : swingWeight // ignore: cast_nullable_to_non_nullable
as double?,twistWeight: freezed == twistWeight ? _self.twistWeight : twistWeight // ignore: cast_nullable_to_non_nullable
as double?,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as PaddleDimensions,gripCircumferenceIn: freezed == gripCircumferenceIn ? _self.gripCircumferenceIn : gripCircumferenceIn // ignore: cast_nullable_to_non_nullable
as double?,ratings: null == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as PaddleRatings,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaddleDimensionsCopyWith<$Res> get dimensions {
  
  return $PaddleDimensionsCopyWith<$Res>(_self.dimensions, (value) {
    return _then(_self.copyWith(dimensions: value));
  });
}/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaddleRatingsCopyWith<$Res> get ratings {
  
  return $PaddleRatingsCopyWith<$Res>(_self.ratings, (value) {
    return _then(_self.copyWith(ratings: value));
  });
}
}


/// Adds pattern-matching-related methods to [Paddle].
extension PaddlePatterns on Paddle {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Paddle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Paddle() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Paddle value)  $default,){
final _that = this;
switch (_that) {
case _Paddle():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Paddle value)?  $default,){
final _that = this;
switch (_that) {
case _Paddle() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String brand,  String name,  int? releaseYear,  double? priceUsd,  bool? inStock,  PaddleShape? shape,  String? faceMaterial,  double? coreThicknessMm,  double? weightOz,  double? swingWeight,  double? twistWeight,  PaddleDimensions dimensions,  double? gripCircumferenceIn,  PaddleRatings ratings,  String? imagePath,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Paddle() when $default != null:
return $default(_that.id,_that.brand,_that.name,_that.releaseYear,_that.priceUsd,_that.inStock,_that.shape,_that.faceMaterial,_that.coreThicknessMm,_that.weightOz,_that.swingWeight,_that.twistWeight,_that.dimensions,_that.gripCircumferenceIn,_that.ratings,_that.imagePath,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String brand,  String name,  int? releaseYear,  double? priceUsd,  bool? inStock,  PaddleShape? shape,  String? faceMaterial,  double? coreThicknessMm,  double? weightOz,  double? swingWeight,  double? twistWeight,  PaddleDimensions dimensions,  double? gripCircumferenceIn,  PaddleRatings ratings,  String? imagePath,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Paddle():
return $default(_that.id,_that.brand,_that.name,_that.releaseYear,_that.priceUsd,_that.inStock,_that.shape,_that.faceMaterial,_that.coreThicknessMm,_that.weightOz,_that.swingWeight,_that.twistWeight,_that.dimensions,_that.gripCircumferenceIn,_that.ratings,_that.imagePath,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String brand,  String name,  int? releaseYear,  double? priceUsd,  bool? inStock,  PaddleShape? shape,  String? faceMaterial,  double? coreThicknessMm,  double? weightOz,  double? swingWeight,  double? twistWeight,  PaddleDimensions dimensions,  double? gripCircumferenceIn,  PaddleRatings ratings,  String? imagePath,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Paddle() when $default != null:
return $default(_that.id,_that.brand,_that.name,_that.releaseYear,_that.priceUsd,_that.inStock,_that.shape,_that.faceMaterial,_that.coreThicknessMm,_that.weightOz,_that.swingWeight,_that.twistWeight,_that.dimensions,_that.gripCircumferenceIn,_that.ratings,_that.imagePath,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _Paddle implements Paddle {
  const _Paddle({required this.id, required this.brand, required this.name, this.releaseYear, this.priceUsd, this.inStock, this.shape, this.faceMaterial, this.coreThicknessMm, this.weightOz, this.swingWeight, this.twistWeight, this.dimensions = const PaddleDimensions(), this.gripCircumferenceIn, this.ratings = const PaddleRatings(), this.imagePath, this.description});
  

@override final  String id;
@override final  String brand;
@override final  String name;
@override final  int? releaseYear;
@override final  double? priceUsd;
@override final  bool? inStock;
@override final  PaddleShape? shape;
@override final  String? faceMaterial;
@override final  double? coreThicknessMm;
@override final  double? weightOz;
@override final  double? swingWeight;
@override final  double? twistWeight;
@override@JsonKey() final  PaddleDimensions dimensions;
@override final  double? gripCircumferenceIn;
@override@JsonKey() final  PaddleRatings ratings;
@override final  String? imagePath;
@override final  String? description;

/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaddleCopyWith<_Paddle> get copyWith => __$PaddleCopyWithImpl<_Paddle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Paddle&&(identical(other.id, id) || other.id == id)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.name, name) || other.name == name)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.priceUsd, priceUsd) || other.priceUsd == priceUsd)&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.faceMaterial, faceMaterial) || other.faceMaterial == faceMaterial)&&(identical(other.coreThicknessMm, coreThicknessMm) || other.coreThicknessMm == coreThicknessMm)&&(identical(other.weightOz, weightOz) || other.weightOz == weightOz)&&(identical(other.swingWeight, swingWeight) || other.swingWeight == swingWeight)&&(identical(other.twistWeight, twistWeight) || other.twistWeight == twistWeight)&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions)&&(identical(other.gripCircumferenceIn, gripCircumferenceIn) || other.gripCircumferenceIn == gripCircumferenceIn)&&(identical(other.ratings, ratings) || other.ratings == ratings)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,brand,name,releaseYear,priceUsd,inStock,shape,faceMaterial,coreThicknessMm,weightOz,swingWeight,twistWeight,dimensions,gripCircumferenceIn,ratings,imagePath,description);
}

@override
String toString() {
    return 'Paddle(id: $id, brand: $brand, name: $name, releaseYear: $releaseYear, priceUsd: $priceUsd, inStock: $inStock, shape: $shape, faceMaterial: $faceMaterial, coreThicknessMm: $coreThicknessMm, weightOz: $weightOz, swingWeight: $swingWeight, twistWeight: $twistWeight, dimensions: $dimensions, gripCircumferenceIn: $gripCircumferenceIn, ratings: $ratings, imagePath: $imagePath, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PaddleCopyWith<$Res> implements $PaddleCopyWith<$Res> {
  factory _$PaddleCopyWith(_Paddle value, $Res Function(_Paddle) _then) = __$PaddleCopyWithImpl;
@override @useResult
$Res call({
 String id, String brand, String name, int? releaseYear, double? priceUsd, bool? inStock, PaddleShape? shape, String? faceMaterial, double? coreThicknessMm, double? weightOz, double? swingWeight, double? twistWeight, PaddleDimensions dimensions, double? gripCircumferenceIn, PaddleRatings ratings, String? imagePath, String? description
});


@override $PaddleDimensionsCopyWith<$Res> get dimensions;@override $PaddleRatingsCopyWith<$Res> get ratings;

}
/// @nodoc
class __$PaddleCopyWithImpl<$Res>
    implements _$PaddleCopyWith<$Res> {
  __$PaddleCopyWithImpl(this._self, this._then);

  final _Paddle _self;
  final $Res Function(_Paddle) _then;

/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brand = null,Object? name = null,Object? releaseYear = freezed,Object? priceUsd = freezed,Object? inStock = freezed,Object? shape = freezed,Object? faceMaterial = freezed,Object? coreThicknessMm = freezed,Object? weightOz = freezed,Object? swingWeight = freezed,Object? twistWeight = freezed,Object? dimensions = null,Object? gripCircumferenceIn = freezed,Object? ratings = null,Object? imagePath = freezed,Object? description = freezed,}) {
  return _then(_Paddle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,priceUsd: freezed == priceUsd ? _self.priceUsd : priceUsd // ignore: cast_nullable_to_non_nullable
as double?,inStock: freezed == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as bool?,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as PaddleShape?,faceMaterial: freezed == faceMaterial ? _self.faceMaterial : faceMaterial // ignore: cast_nullable_to_non_nullable
as String?,coreThicknessMm: freezed == coreThicknessMm ? _self.coreThicknessMm : coreThicknessMm // ignore: cast_nullable_to_non_nullable
as double?,weightOz: freezed == weightOz ? _self.weightOz : weightOz // ignore: cast_nullable_to_non_nullable
as double?,swingWeight: freezed == swingWeight ? _self.swingWeight : swingWeight // ignore: cast_nullable_to_non_nullable
as double?,twistWeight: freezed == twistWeight ? _self.twistWeight : twistWeight // ignore: cast_nullable_to_non_nullable
as double?,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as PaddleDimensions,gripCircumferenceIn: freezed == gripCircumferenceIn ? _self.gripCircumferenceIn : gripCircumferenceIn // ignore: cast_nullable_to_non_nullable
as double?,ratings: null == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as PaddleRatings,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaddleDimensionsCopyWith<$Res> get dimensions {
  
  return $PaddleDimensionsCopyWith<$Res>(_self.dimensions, (value) {
    return _then(_self.copyWith(dimensions: value));
  });
}/// Create a copy of Paddle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaddleRatingsCopyWith<$Res> get ratings {
  
  return $PaddleRatingsCopyWith<$Res>(_self.ratings, (value) {
    return _then(_self.copyWith(ratings: value));
  });
}
}

// dart format on
