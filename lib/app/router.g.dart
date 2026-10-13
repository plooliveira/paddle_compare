// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$catalogRoute];

RouteBase get $catalogRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $CatalogRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'paddles/:id',
      hasOverriddenOnExit: false,
      factory: $PaddleDetailRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'compare',
      hasOverriddenOnExit: false,
      factory: $CompareRoute._fromState,
    ),
  ],
);

mixin $CatalogRoute on GoRouteData {
  static CatalogRoute _fromState(GoRouterState state) => CatalogRoute(
    q: state.uri.queryParameters['q'],
    shape:
        state.uri.queryParametersAll['shape']?.map((e) => e).toList() ??
        const [],
    minPrice: state.uri.queryParameters['min-price'],
    maxPrice: state.uri.queryParameters['max-price'],
    inStock: state.uri.queryParameters['in-stock'],
    sort: state.uri.queryParameters['sort'],
  );

  CatalogRoute get _self => this as CatalogRoute;

  @override
  String get location => GoRouteData.$location(
    '/',
    queryParams: {
      if (_self.q != null) 'q': _self.q,
      if (!_$iterablesEqual(_self.shape, const []))
        'shape': _self.shape.map((e) => e).toList(),
      if (_self.minPrice != null) 'min-price': _self.minPrice,
      if (_self.maxPrice != null) 'max-price': _self.maxPrice,
      if (_self.inStock != null) 'in-stock': _self.inStock,
      if (_self.sort != null) 'sort': _self.sort,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PaddleDetailRoute on GoRouteData {
  static PaddleDetailRoute _fromState(GoRouterState state) =>
      PaddleDetailRoute(id: state.pathParameters['id']!);

  PaddleDetailRoute get _self => this as PaddleDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/paddles/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CompareRoute on GoRouteData {
  static CompareRoute _fromState(GoRouterState state) => CompareRoute(
    ids:
        state.uri.queryParametersAll['ids']?.map((e) => e).toList() ?? const [],
  );

  CompareRoute get _self => this as CompareRoute;

  @override
  String get location => GoRouteData.$location(
    '/compare',
    queryParams: {
      if (!_$iterablesEqual(_self.ids, const []))
        'ids': _self.ids.map((e) => e).toList(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

bool _$iterablesEqual<T>(Iterable<T>? iterable1, Iterable<T>? iterable2) {
  if (identical(iterable1, iterable2)) return true;
  if (iterable1 == null || iterable2 == null) return false;
  final iterator1 = iterable1.iterator;
  final iterator2 = iterable2.iterator;
  while (true) {
    final hasNext1 = iterator1.moveNext();
    final hasNext2 = iterator2.moveNext();
    if (hasNext1 != hasNext2) return false;
    if (!hasNext1) return true;
    if (iterator1.current != iterator2.current) return false;
  }
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(router)
final routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'b1ad23e6509f303b4378d069298c7b359dc7d72b';
