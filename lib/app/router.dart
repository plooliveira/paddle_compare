import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/paddle/paddle_repository.dart';
import 'catalog/controller/catalog_filter.dart';
import 'catalog/view/catalog_view.dart';
import 'compare/controller/compare_limits.dart';
import 'compare/view/compare_view.dart';
import 'paddle_detail/view/paddle_detail_view.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(initialLocation: '/', routes: $appRoutes);
  ref.onDispose(router.dispose);
  return router;
}

/// Parameters are kept as raw strings and parsed by [filter] and [compareIds],
/// so a hand-edited URL never lands on the error page.
///
/// Pages nested under the catalog carry its query in their own URL, so the
/// catalog underneath is rebuilt the same on a refresh or a shared link. They
/// are opened through [pushDetails] and [goCompare], never the generated
/// `push` of the child routes.
@TypedGoRoute<CatalogRoute>(
  path: '/',
  routes: [
    TypedGoRoute<PaddleDetailRoute>(path: 'paddles/:id'),
    TypedGoRoute<CompareRoute>(path: 'compare'),
  ],
)
class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute({
    this.q,
    this.shape = const [],
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.sort,
    this.compare = const [],
  });

  /// Leaves out every default, so the default filter is `/`.
  ///
  /// [compare] is required, so a filter change never drops the comparison by
  /// accident.
  factory CatalogRoute.fromFilter(
    CatalogFilter filter, {
    required List<String> compare,
  }) => CatalogRoute(
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
    compare: compare,
  );

  /// The catalog underneath the page of [context], read from that page's URL.
  ///
  /// Only works in go_router's pages, not in sheets pushed imperatively.
  factory CatalogRoute.of(BuildContext context) =>
      $CatalogRoute._fromState(GoRouterState.of(context));

  final String? q;
  final List<String> shape;
  final String? minPrice;
  final String? maxPrice;
  final String? inStock;
  final String? sort;
  final List<String> compare;

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

  List<String> get compareIds => List.unmodifiable(
    {
      for (final id in compare)
        if (id.trim() case final id when id.isNotEmpty) id,
    }.take(CompareLimits.max),
  );

  CatalogRoute withCompare(List<String> ids) => CatalogRoute(
    q: q,
    shape: shape,
    minPrice: minPrice,
    maxPrice: maxPrice,
    inStock: inStock,
    sort: sort,
    compare: ids,
  );

  /// Adds [id] to the comparison. If that makes [limit] paddles, the
  /// comparison opens. Otherwise the catalog shows with the paddle in its
  /// tray: in place from the catalog, or back from a page above it, which
  /// leaves with its pop animation. Either way the catalog keeps its page and
  /// filter, so the grid doesn't reload.
  ///
  /// [limit] comes from the caller (`CompareLimits.of`): routes don't apply
  /// form-factor rules.
  void addToCompare(BuildContext context, String id, {required int limit}) {
    final next = withCompare([...compareIds, id]);
    if (next.compareIds.length >= limit) {
      next.goCompare(context);
    } else if (GoRouterState.of(context).uri.path == Uri.parse(location).path) {
      next.goInPlace(context);
    } else {
      next.go(context);
    }
  }

  /// Updates the URL without a history entry, so Back leaves the catalog
  /// instead of undoing filters one by one.
  void goInPlace(BuildContext context) =>
      Router.neglect(context, () => go(context));

  Future<void> pushDetails(BuildContext context, String id) =>
      context.push(_nested(PaddleDetailRoute(id: id)));

  /// Opens the comparison over this catalog. A single `go` updates the
  /// catalog underneath and opens the sheet: pushing after [goInPlace] would
  /// race, since the push starts from the configuration before it.
  void goCompare(BuildContext context) =>
      context.go(_nested(const CompareRoute()));

  String _nested(GoRouteData child) {
    final path = Uri.parse(child.location);
    assert(!path.hasQuery, 'Pages under the catalog carry its query only.');
    return Uri.parse(location).replace(path: path.path).toString();
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CatalogView(filter: filter, compareIds: compareIds);
}

class PaddleDetailRoute extends GoRouteData with $PaddleDetailRoute {
  const PaddleDetailRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaddleDetailView(
    id: id,
    compareIds: $CatalogRoute._fromState(state).compareIds,
  );
}

class CompareRoute extends GoRouteData with $CompareRoute {
  const CompareRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => _SheetPage(
    key: state.pageKey,
    child: CompareView(ids: $CatalogRoute._fromState(state).compareIds),
  );
}

/// A page shown as a modal bottom sheet. Being a page, it is in the URL: a
/// refresh opens it again, and closing it (drag, barrier, Back) pops the
/// route.
class _SheetPage<T> extends Page<T> {
  const _SheetPage({super.key, required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    late final ModalBottomSheetRoute<T> route;
    route = ModalBottomSheetRoute<T>(
      settings: this,
      // Reads the current page, like MaterialPage does, so a new URL updates
      // the open sheet.
      builder: (_) => (route.settings as _SheetPage<T>).child,
      isScrollControlled: true,
      useSafeArea: true,
      // What showModalBottomSheet would pass.
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(
        localizations.bottomSheetLabel,
      ),
      modalBarrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
    );
    return route;
  }
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
