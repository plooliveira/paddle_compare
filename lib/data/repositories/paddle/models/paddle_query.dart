import 'package:freezed_annotation/freezed_annotation.dart';

import 'paddle_shape.dart';
import 'paddle_sort.dart';

part 'paddle_query.freezed.dart';

/// Search, filters and sort for `PaddleRepository.getPaddles`.
///
/// A paddle missing the data an active criterion needs (e.g. no price while a
/// price range is set) is left out. When the sort needs data a paddle lacks,
/// that paddle goes last.
@freezed
abstract class PaddleQuery with _$PaddleQuery {
  const factory PaddleQuery({
    /// Matched against brand or name, ignoring case. Null matches everything.
    String? search,

    /// Empty means every shape.
    @Default(<PaddleShape>{}) Set<PaddleShape> shapes,

    /// Inclusive. Null means no limit on that end.
    double? minPrice,
    double? maxPrice,
    @Default(false) bool inStockOnly,
    @Default(PaddleSort.featured) PaddleSort sort,
  }) = _PaddleQuery;
}
