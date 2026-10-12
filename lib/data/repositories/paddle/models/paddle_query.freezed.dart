// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paddle_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaddleQuery {

/// Matched against brand or name, ignoring case. Null matches everything.
 String? get search;/// Empty means every shape.
 Set<PaddleShape> get shapes;/// Inclusive. Null means no limit on that end.
 double? get minPrice; double? get maxPrice; bool get inStockOnly; PaddleSort get sort;
/// Create a copy of PaddleQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaddleQueryCopyWith<PaddleQuery> get copyWith => _$PaddleQueryCopyWithImpl<PaddleQuery>(this as PaddleQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaddleQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaddleQuery&&(identical(other.search, _this.search) || other.search == _this.search)&&const DeepCollectionEquality().equals(other.shapes, _this.shapes)&&(identical(other.minPrice, _this.minPrice) || other.minPrice == _this.minPrice)&&(identical(other.maxPrice, _this.maxPrice) || other.maxPrice == _this.maxPrice)&&(identical(other.inStockOnly, _this.inStockOnly) || other.inStockOnly == _this.inStockOnly)&&(identical(other.sort, _this.sort) || other.sort == _this.sort));
}


@override
int get hashCode {
  final _this = this as PaddleQuery;
  return Object.hash(runtimeType,_this.search,const DeepCollectionEquality().hash(_this.shapes),_this.minPrice,_this.maxPrice,_this.inStockOnly,_this.sort);
}

@override
String toString() {
  final _this = this as PaddleQuery;
  return 'PaddleQuery(search: ${_this.search}, shapes: ${_this.shapes}, minPrice: ${_this.minPrice}, maxPrice: ${_this.maxPrice}, inStockOnly: ${_this.inStockOnly}, sort: ${_this.sort})';
}


}

/// @nodoc
abstract mixin class $PaddleQueryCopyWith<$Res>  {
  factory $PaddleQueryCopyWith(PaddleQuery value, $Res Function(PaddleQuery) _then) = _$PaddleQueryCopyWithImpl;
@useResult
$Res call({
 String? search, Set<PaddleShape> shapes, double? minPrice, double? maxPrice, bool inStockOnly, PaddleSort sort
});




}
/// @nodoc
class _$PaddleQueryCopyWithImpl<$Res>
    implements $PaddleQueryCopyWith<$Res> {
  _$PaddleQueryCopyWithImpl(this._self, this._then);

  final PaddleQuery _self;
  final $Res Function(PaddleQuery) _then;

/// Create a copy of PaddleQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = freezed,Object? shapes = null,Object? minPrice = freezed,Object? maxPrice = freezed,Object? inStockOnly = null,Object? sort = null,}) {
  return _then(PaddleQuery(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,shapes: null == shapes ? _self.shapes : shapes // ignore: cast_nullable_to_non_nullable
as Set<PaddleShape>,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,inStockOnly: null == inStockOnly ? _self.inStockOnly : inStockOnly // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as PaddleSort,
  ));
}

}


/// Adds pattern-matching-related methods to [PaddleQuery].
extension PaddleQueryPatterns on PaddleQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaddleQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaddleQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaddleQuery value)  $default,){
final _that = this;
switch (_that) {
case _PaddleQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaddleQuery value)?  $default,){
final _that = this;
switch (_that) {
case _PaddleQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? search,  Set<PaddleShape> shapes,  double? minPrice,  double? maxPrice,  bool inStockOnly,  PaddleSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaddleQuery() when $default != null:
return $default(_that.search,_that.shapes,_that.minPrice,_that.maxPrice,_that.inStockOnly,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? search,  Set<PaddleShape> shapes,  double? minPrice,  double? maxPrice,  bool inStockOnly,  PaddleSort sort)  $default,) {final _that = this;
switch (_that) {
case _PaddleQuery():
return $default(_that.search,_that.shapes,_that.minPrice,_that.maxPrice,_that.inStockOnly,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? search,  Set<PaddleShape> shapes,  double? minPrice,  double? maxPrice,  bool inStockOnly,  PaddleSort sort)?  $default,) {final _that = this;
switch (_that) {
case _PaddleQuery() when $default != null:
return $default(_that.search,_that.shapes,_that.minPrice,_that.maxPrice,_that.inStockOnly,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _PaddleQuery implements PaddleQuery {
  const _PaddleQuery({this.search,  Set<PaddleShape> shapes = const <PaddleShape>{}, this.minPrice, this.maxPrice, this.inStockOnly = false, this.sort = PaddleSort.featured}): _shapes = shapes;
  

/// Matched against brand or name, ignoring case. Null matches everything.
@override final  String? search;
/// Empty means every shape.
 final  Set<PaddleShape> _shapes;
/// Empty means every shape.
@override@JsonKey() Set<PaddleShape> get shapes {
  if (_shapes is EqualUnmodifiableSetView) return _shapes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_shapes);
}

/// Inclusive. Null means no limit on that end.
@override final  double? minPrice;
@override final  double? maxPrice;
@override@JsonKey() final  bool inStockOnly;
@override@JsonKey() final  PaddleSort sort;

/// Create a copy of PaddleQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaddleQueryCopyWith<_PaddleQuery> get copyWith => __$PaddleQueryCopyWithImpl<_PaddleQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaddleQuery&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other.shapes, _shapes)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.inStockOnly, inStockOnly) || other.inStockOnly == inStockOnly)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,search,const DeepCollectionEquality().hash(_shapes),minPrice,maxPrice,inStockOnly,sort);
}

@override
String toString() {
    return 'PaddleQuery(search: $search, shapes: $shapes, minPrice: $minPrice, maxPrice: $maxPrice, inStockOnly: $inStockOnly, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$PaddleQueryCopyWith<$Res> implements $PaddleQueryCopyWith<$Res> {
  factory _$PaddleQueryCopyWith(_PaddleQuery value, $Res Function(_PaddleQuery) _then) = __$PaddleQueryCopyWithImpl;
@override @useResult
$Res call({
 String? search, Set<PaddleShape> shapes, double? minPrice, double? maxPrice, bool inStockOnly, PaddleSort sort
});




}
/// @nodoc
class __$PaddleQueryCopyWithImpl<$Res>
    implements _$PaddleQueryCopyWith<$Res> {
  __$PaddleQueryCopyWithImpl(this._self, this._then);

  final _PaddleQuery _self;
  final $Res Function(_PaddleQuery) _then;

/// Create a copy of PaddleQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = freezed,Object? shapes = null,Object? minPrice = freezed,Object? maxPrice = freezed,Object? inStockOnly = null,Object? sort = null,}) {
  return _then(_PaddleQuery(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,shapes: null == shapes ? _self._shapes : shapes // ignore: cast_nullable_to_non_nullable
as Set<PaddleShape>,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,inStockOnly: null == inStockOnly ? _self.inStockOnly : inStockOnly // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as PaddleSort,
  ));
}


}

// dart format on
