// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogFilter {

 String get query; Set<PaddleShape> get shapes; double? get minPrice; double? get maxPrice; bool get inStockOnly; PaddleSort get sort;
/// Create a copy of CatalogFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogFilterCopyWith<CatalogFilter> get copyWith => _$CatalogFilterCopyWithImpl<CatalogFilter>(this as CatalogFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogFilter&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.shapes, _this.shapes)&&(identical(other.minPrice, _this.minPrice) || other.minPrice == _this.minPrice)&&(identical(other.maxPrice, _this.maxPrice) || other.maxPrice == _this.maxPrice)&&(identical(other.inStockOnly, _this.inStockOnly) || other.inStockOnly == _this.inStockOnly)&&(identical(other.sort, _this.sort) || other.sort == _this.sort));
}


@override
int get hashCode {
  final _this = this as CatalogFilter;
  return Object.hash(runtimeType,_this.query,const DeepCollectionEquality().hash(_this.shapes),_this.minPrice,_this.maxPrice,_this.inStockOnly,_this.sort);
}

@override
String toString() {
  final _this = this as CatalogFilter;
  return 'CatalogFilter(query: ${_this.query}, shapes: ${_this.shapes}, minPrice: ${_this.minPrice}, maxPrice: ${_this.maxPrice}, inStockOnly: ${_this.inStockOnly}, sort: ${_this.sort})';
}


}

/// @nodoc
abstract mixin class $CatalogFilterCopyWith<$Res>  {
  factory $CatalogFilterCopyWith(CatalogFilter value, $Res Function(CatalogFilter) _then) = _$CatalogFilterCopyWithImpl;
@useResult
$Res call({
 String query, Set<PaddleShape> shapes, double? minPrice, double? maxPrice, bool inStockOnly, PaddleSort sort
});




}
/// @nodoc
class _$CatalogFilterCopyWithImpl<$Res>
    implements $CatalogFilterCopyWith<$Res> {
  _$CatalogFilterCopyWithImpl(this._self, this._then);

  final CatalogFilter _self;
  final $Res Function(CatalogFilter) _then;

/// Create a copy of CatalogFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? shapes = null,Object? minPrice = freezed,Object? maxPrice = freezed,Object? inStockOnly = null,Object? sort = null,}) {
  return _then(CatalogFilter(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,shapes: null == shapes ? _self.shapes : shapes // ignore: cast_nullable_to_non_nullable
as Set<PaddleShape>,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,inStockOnly: null == inStockOnly ? _self.inStockOnly : inStockOnly // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as PaddleSort,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogFilter].
extension CatalogFilterPatterns on CatalogFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogFilter value)  $default,){
final _that = this;
switch (_that) {
case _CatalogFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogFilter value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  Set<PaddleShape> shapes,  double? minPrice,  double? maxPrice,  bool inStockOnly,  PaddleSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogFilter() when $default != null:
return $default(_that.query,_that.shapes,_that.minPrice,_that.maxPrice,_that.inStockOnly,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  Set<PaddleShape> shapes,  double? minPrice,  double? maxPrice,  bool inStockOnly,  PaddleSort sort)  $default,) {final _that = this;
switch (_that) {
case _CatalogFilter():
return $default(_that.query,_that.shapes,_that.minPrice,_that.maxPrice,_that.inStockOnly,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  Set<PaddleShape> shapes,  double? minPrice,  double? maxPrice,  bool inStockOnly,  PaddleSort sort)?  $default,) {final _that = this;
switch (_that) {
case _CatalogFilter() when $default != null:
return $default(_that.query,_that.shapes,_that.minPrice,_that.maxPrice,_that.inStockOnly,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogFilter extends CatalogFilter {
  const _CatalogFilter({this.query = '',  Set<PaddleShape> shapes = const <PaddleShape>{}, this.minPrice, this.maxPrice, this.inStockOnly = false, this.sort = PaddleSort.featured}): _shapes = shapes,super._();
  

@override@JsonKey() final  String query;
 final  Set<PaddleShape> _shapes;
@override@JsonKey() Set<PaddleShape> get shapes {
  if (_shapes is EqualUnmodifiableSetView) return _shapes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_shapes);
}

@override final  double? minPrice;
@override final  double? maxPrice;
@override@JsonKey() final  bool inStockOnly;
@override@JsonKey() final  PaddleSort sort;

/// Create a copy of CatalogFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogFilterCopyWith<_CatalogFilter> get copyWith => __$CatalogFilterCopyWithImpl<_CatalogFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogFilter&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.shapes, _shapes)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.inStockOnly, inStockOnly) || other.inStockOnly == inStockOnly)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_shapes),minPrice,maxPrice,inStockOnly,sort);
}

@override
String toString() {
    return 'CatalogFilter(query: $query, shapes: $shapes, minPrice: $minPrice, maxPrice: $maxPrice, inStockOnly: $inStockOnly, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$CatalogFilterCopyWith<$Res> implements $CatalogFilterCopyWith<$Res> {
  factory _$CatalogFilterCopyWith(_CatalogFilter value, $Res Function(_CatalogFilter) _then) = __$CatalogFilterCopyWithImpl;
@override @useResult
$Res call({
 String query, Set<PaddleShape> shapes, double? minPrice, double? maxPrice, bool inStockOnly, PaddleSort sort
});




}
/// @nodoc
class __$CatalogFilterCopyWithImpl<$Res>
    implements _$CatalogFilterCopyWith<$Res> {
  __$CatalogFilterCopyWithImpl(this._self, this._then);

  final _CatalogFilter _self;
  final $Res Function(_CatalogFilter) _then;

/// Create a copy of CatalogFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? shapes = null,Object? minPrice = freezed,Object? maxPrice = freezed,Object? inStockOnly = null,Object? sort = null,}) {
  return _then(_CatalogFilter(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,shapes: null == shapes ? _self._shapes : shapes // ignore: cast_nullable_to_non_nullable
as Set<PaddleShape>,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,inStockOnly: null == inStockOnly ? _self.inStockOnly : inStockOnly // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as PaddleSort,
  ));
}


}

// dart format on
