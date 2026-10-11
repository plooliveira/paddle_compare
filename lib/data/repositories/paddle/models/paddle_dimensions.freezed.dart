// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paddle_dimensions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaddleDimensions {

 double? get lengthIn; double? get widthIn; double? get handleLengthIn;
/// Create a copy of PaddleDimensions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaddleDimensionsCopyWith<PaddleDimensions> get copyWith => _$PaddleDimensionsCopyWithImpl<PaddleDimensions>(this as PaddleDimensions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaddleDimensions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaddleDimensions&&(identical(other.lengthIn, _this.lengthIn) || other.lengthIn == _this.lengthIn)&&(identical(other.widthIn, _this.widthIn) || other.widthIn == _this.widthIn)&&(identical(other.handleLengthIn, _this.handleLengthIn) || other.handleLengthIn == _this.handleLengthIn));
}


@override
int get hashCode {
  final _this = this as PaddleDimensions;
  return Object.hash(runtimeType,_this.lengthIn,_this.widthIn,_this.handleLengthIn);
}

@override
String toString() {
  final _this = this as PaddleDimensions;
  return 'PaddleDimensions(lengthIn: ${_this.lengthIn}, widthIn: ${_this.widthIn}, handleLengthIn: ${_this.handleLengthIn})';
}


}

/// @nodoc
abstract mixin class $PaddleDimensionsCopyWith<$Res>  {
  factory $PaddleDimensionsCopyWith(PaddleDimensions value, $Res Function(PaddleDimensions) _then) = _$PaddleDimensionsCopyWithImpl;
@useResult
$Res call({
 double? lengthIn, double? widthIn, double? handleLengthIn
});




}
/// @nodoc
class _$PaddleDimensionsCopyWithImpl<$Res>
    implements $PaddleDimensionsCopyWith<$Res> {
  _$PaddleDimensionsCopyWithImpl(this._self, this._then);

  final PaddleDimensions _self;
  final $Res Function(PaddleDimensions) _then;

/// Create a copy of PaddleDimensions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lengthIn = freezed,Object? widthIn = freezed,Object? handleLengthIn = freezed,}) {
  return _then(PaddleDimensions(
lengthIn: freezed == lengthIn ? _self.lengthIn : lengthIn // ignore: cast_nullable_to_non_nullable
as double?,widthIn: freezed == widthIn ? _self.widthIn : widthIn // ignore: cast_nullable_to_non_nullable
as double?,handleLengthIn: freezed == handleLengthIn ? _self.handleLengthIn : handleLengthIn // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaddleDimensions].
extension PaddleDimensionsPatterns on PaddleDimensions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaddleDimensions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaddleDimensions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaddleDimensions value)  $default,){
final _that = this;
switch (_that) {
case _PaddleDimensions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaddleDimensions value)?  $default,){
final _that = this;
switch (_that) {
case _PaddleDimensions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? lengthIn,  double? widthIn,  double? handleLengthIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaddleDimensions() when $default != null:
return $default(_that.lengthIn,_that.widthIn,_that.handleLengthIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? lengthIn,  double? widthIn,  double? handleLengthIn)  $default,) {final _that = this;
switch (_that) {
case _PaddleDimensions():
return $default(_that.lengthIn,_that.widthIn,_that.handleLengthIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? lengthIn,  double? widthIn,  double? handleLengthIn)?  $default,) {final _that = this;
switch (_that) {
case _PaddleDimensions() when $default != null:
return $default(_that.lengthIn,_that.widthIn,_that.handleLengthIn);case _:
  return null;

}
}

}

/// @nodoc


class _PaddleDimensions implements PaddleDimensions {
  const _PaddleDimensions({this.lengthIn, this.widthIn, this.handleLengthIn});
  

@override final  double? lengthIn;
@override final  double? widthIn;
@override final  double? handleLengthIn;

/// Create a copy of PaddleDimensions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaddleDimensionsCopyWith<_PaddleDimensions> get copyWith => __$PaddleDimensionsCopyWithImpl<_PaddleDimensions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaddleDimensions&&(identical(other.lengthIn, lengthIn) || other.lengthIn == lengthIn)&&(identical(other.widthIn, widthIn) || other.widthIn == widthIn)&&(identical(other.handleLengthIn, handleLengthIn) || other.handleLengthIn == handleLengthIn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lengthIn,widthIn,handleLengthIn);
}

@override
String toString() {
    return 'PaddleDimensions(lengthIn: $lengthIn, widthIn: $widthIn, handleLengthIn: $handleLengthIn)';
}


}

/// @nodoc
abstract mixin class _$PaddleDimensionsCopyWith<$Res> implements $PaddleDimensionsCopyWith<$Res> {
  factory _$PaddleDimensionsCopyWith(_PaddleDimensions value, $Res Function(_PaddleDimensions) _then) = __$PaddleDimensionsCopyWithImpl;
@override @useResult
$Res call({
 double? lengthIn, double? widthIn, double? handleLengthIn
});




}
/// @nodoc
class __$PaddleDimensionsCopyWithImpl<$Res>
    implements _$PaddleDimensionsCopyWith<$Res> {
  __$PaddleDimensionsCopyWithImpl(this._self, this._then);

  final _PaddleDimensions _self;
  final $Res Function(_PaddleDimensions) _then;

/// Create a copy of PaddleDimensions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lengthIn = freezed,Object? widthIn = freezed,Object? handleLengthIn = freezed,}) {
  return _then(_PaddleDimensions(
lengthIn: freezed == lengthIn ? _self.lengthIn : lengthIn // ignore: cast_nullable_to_non_nullable
as double?,widthIn: freezed == widthIn ? _self.widthIn : widthIn // ignore: cast_nullable_to_non_nullable
as double?,handleLengthIn: freezed == handleLengthIn ? _self.handleLengthIn : handleLengthIn // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
