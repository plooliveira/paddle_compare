// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paddle_ratings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaddleRatings {

 int? get power; int? get control; int? get spin; int? get pop;
/// Create a copy of PaddleRatings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaddleRatingsCopyWith<PaddleRatings> get copyWith => _$PaddleRatingsCopyWithImpl<PaddleRatings>(this as PaddleRatings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaddleRatings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaddleRatings&&(identical(other.power, _this.power) || other.power == _this.power)&&(identical(other.control, _this.control) || other.control == _this.control)&&(identical(other.spin, _this.spin) || other.spin == _this.spin)&&(identical(other.pop, _this.pop) || other.pop == _this.pop));
}


@override
int get hashCode {
  final _this = this as PaddleRatings;
  return Object.hash(runtimeType,_this.power,_this.control,_this.spin,_this.pop);
}

@override
String toString() {
  final _this = this as PaddleRatings;
  return 'PaddleRatings(power: ${_this.power}, control: ${_this.control}, spin: ${_this.spin}, pop: ${_this.pop})';
}


}

/// @nodoc
abstract mixin class $PaddleRatingsCopyWith<$Res>  {
  factory $PaddleRatingsCopyWith(PaddleRatings value, $Res Function(PaddleRatings) _then) = _$PaddleRatingsCopyWithImpl;
@useResult
$Res call({
 int? power, int? control, int? spin, int? pop
});




}
/// @nodoc
class _$PaddleRatingsCopyWithImpl<$Res>
    implements $PaddleRatingsCopyWith<$Res> {
  _$PaddleRatingsCopyWithImpl(this._self, this._then);

  final PaddleRatings _self;
  final $Res Function(PaddleRatings) _then;

/// Create a copy of PaddleRatings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? power = freezed,Object? control = freezed,Object? spin = freezed,Object? pop = freezed,}) {
  return _then(PaddleRatings(
power: freezed == power ? _self.power : power // ignore: cast_nullable_to_non_nullable
as int?,control: freezed == control ? _self.control : control // ignore: cast_nullable_to_non_nullable
as int?,spin: freezed == spin ? _self.spin : spin // ignore: cast_nullable_to_non_nullable
as int?,pop: freezed == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaddleRatings].
extension PaddleRatingsPatterns on PaddleRatings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaddleRatings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaddleRatings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaddleRatings value)  $default,){
final _that = this;
switch (_that) {
case _PaddleRatings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaddleRatings value)?  $default,){
final _that = this;
switch (_that) {
case _PaddleRatings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? power,  int? control,  int? spin,  int? pop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaddleRatings() when $default != null:
return $default(_that.power,_that.control,_that.spin,_that.pop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? power,  int? control,  int? spin,  int? pop)  $default,) {final _that = this;
switch (_that) {
case _PaddleRatings():
return $default(_that.power,_that.control,_that.spin,_that.pop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? power,  int? control,  int? spin,  int? pop)?  $default,) {final _that = this;
switch (_that) {
case _PaddleRatings() when $default != null:
return $default(_that.power,_that.control,_that.spin,_that.pop);case _:
  return null;

}
}

}

/// @nodoc


class _PaddleRatings implements PaddleRatings {
  const _PaddleRatings({this.power, this.control, this.spin, this.pop});
  

@override final  int? power;
@override final  int? control;
@override final  int? spin;
@override final  int? pop;

/// Create a copy of PaddleRatings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaddleRatingsCopyWith<_PaddleRatings> get copyWith => __$PaddleRatingsCopyWithImpl<_PaddleRatings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaddleRatings&&(identical(other.power, power) || other.power == power)&&(identical(other.control, control) || other.control == control)&&(identical(other.spin, spin) || other.spin == spin)&&(identical(other.pop, pop) || other.pop == pop));
}


@override
int get hashCode {
    return Object.hash(runtimeType,power,control,spin,pop);
}

@override
String toString() {
    return 'PaddleRatings(power: $power, control: $control, spin: $spin, pop: $pop)';
}


}

/// @nodoc
abstract mixin class _$PaddleRatingsCopyWith<$Res> implements $PaddleRatingsCopyWith<$Res> {
  factory _$PaddleRatingsCopyWith(_PaddleRatings value, $Res Function(_PaddleRatings) _then) = __$PaddleRatingsCopyWithImpl;
@override @useResult
$Res call({
 int? power, int? control, int? spin, int? pop
});




}
/// @nodoc
class __$PaddleRatingsCopyWithImpl<$Res>
    implements _$PaddleRatingsCopyWith<$Res> {
  __$PaddleRatingsCopyWithImpl(this._self, this._then);

  final _PaddleRatings _self;
  final $Res Function(_PaddleRatings) _then;

/// Create a copy of PaddleRatings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? power = freezed,Object? control = freezed,Object? spin = freezed,Object? pop = freezed,}) {
  return _then(_PaddleRatings(
power: freezed == power ? _self.power : power // ignore: cast_nullable_to_non_nullable
as int?,control: freezed == control ? _self.control : control // ignore: cast_nullable_to_non_nullable
as int?,spin: freezed == spin ? _self.spin : spin // ignore: cast_nullable_to_non_nullable
as int?,pop: freezed == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
