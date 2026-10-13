import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repositories/paddle/paddle_repository.dart';

part 'catalog_filter.freezed.dart';

@freezed
abstract class CatalogFilter with _$CatalogFilter {
  const CatalogFilter._();

  const factory CatalogFilter({
    @Default('') String query,

    @Default(<PaddleShape>{}) Set<PaddleShape> shapes,
    double? minPrice,
    double? maxPrice,
    @Default(false) bool inStockOnly,
    @Default(PaddleSort.featured) PaddleSort sort,
  }) = _CatalogFilter;

  static const priceBoundMin = 0.0;
  static const priceBoundMax = 300.0;

  int get activeFilterCount =>
      shapes.length +
      (minPrice != null || maxPrice != null ? 1 : 0) +
      (inStockOnly ? 1 : 0);

  PaddleQuery toQuery() {
    final search = query.trim();
    return PaddleQuery(
      search: search.isEmpty ? null : search,
      shapes: shapes,
      minPrice: minPrice,
      maxPrice: maxPrice,
      inStockOnly: inStockOnly,
      sort: sort,
    );
  }

  CatalogFilter toggleShape(PaddleShape shape) {
    final shapes = {...this.shapes};
    if (!shapes.remove(shape)) shapes.add(shape);
    return copyWith(shapes: shapes);
  }

  CatalogFilter cleared() => CatalogFilter(sort: sort);

  CatalogFilter reset() => CatalogFilter(query: query, sort: sort);
}
