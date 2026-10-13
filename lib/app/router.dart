import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/paddle/paddle_repository.dart';
import 'catalog/controller/catalog_filter.dart';
import 'catalog/view/catalog_view.dart';
import 'paddle_detail/view/paddle_detail_view.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(initialLocation: '/', routes: $appRoutes);
  ref.onDispose(router.dispose);
  return router;
}

/// The catalog, with its filter in the query:
/// `/?q=apex&shape=hybrid&max-price=200&in-stock=true&sort=price-asc`.
///
/// Parameters are kept as raw strings and parsed by [filter], so a hand-edited
/// URL never lands on the error page.
@TypedGoRoute<CatalogRoute>(
  path: '/',
  routes: [TypedGoRoute<PaddleDetailRoute>(path: 'paddles/:id')],
)
class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute({
    this.q,
    this.shape = const [],
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.sort,
  });

  /// Leaves out every default, so the default filter is `/`.
  factory CatalogRoute.fromFilter(CatalogFilter filter) => CatalogRoute(
    q: filter.query.isEmpty ? null : filter.query,
    // In enum order, so the same filter always gives the same URL.
    shape: [
      for (final shape in PaddleShape.values)
        if (filter.shapes.contains(shape)) shape.name,
    ],
    minPrice: _formatPrice(filter.minPrice),
    maxPrice: _formatPrice(filter.maxPrice),
    inStock: filter.inStockOnly ? 'true' : null,
    sort: _sortParams[filter.sort],
  );

  final String? q;
  final List<String> shape;
  final String? minPrice;
  final String? maxPrice;
  final String? inStock;
  final String? sort;

  /// Unknown values are ignored. Prices are clamped to the filter's bounds,
  /// a bound means no limit, and a min above the max swaps them.
  CatalogFilter get filter {
    var min = _parsePrice(minPrice);
    var max = _parsePrice(maxPrice);
    if (min != null && max != null && min > max) (min, max) = (max, min);
    return CatalogFilter(
      query: q ?? '',
      shapes: {for (final value in shape) ?PaddleShape.tryParse(value)},
      minPrice: min == CatalogFilter.priceBoundMin ? null : min,
      maxPrice: max == CatalogFilter.priceBoundMax ? null : max,
      inStockOnly: inStock == 'true',
      sort: _sortsByParam[sort] ?? PaddleSort.featured,
    );
  }

  /// Updates the URL without a history entry, so Back leaves the catalog
  /// instead of undoing filters one by one.
  void goInPlace(BuildContext context) =>
      Router.neglect(context, () => go(context));

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CatalogView(filter: filter);
}

/// A paddle's specs. Nested under the catalog, so a deep link has the catalog
/// underneath to go back to.
class PaddleDetailRoute extends GoRouteData with $PaddleDetailRoute {
  const PaddleDetailRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PaddleDetailView(id: id);
}

/// Featured is the default, so it has no parameter.
const _sortParams = {
  PaddleSort.priceLowToHigh: 'price-asc',
  PaddleSort.priceHighToLow: 'price-desc',
  PaddleSort.power: 'power',
};
final _sortsByParam = {
  for (final MapEntry(:key, :value) in _sortParams.entries) value: key,
};

String? _formatPrice(double? price) => switch (price) {
  null => null,
  final price when price == price.roundToDouble() => '${price.toInt()}',
  final price => '$price',
};

double? _parsePrice(String? value) => switch (double.tryParse(value ?? '')) {
  final price? when price.isFinite => price.clamp(
    CatalogFilter.priceBoundMin,
    CatalogFilter.priceBoundMax,
  ),
  _ => null,
};
