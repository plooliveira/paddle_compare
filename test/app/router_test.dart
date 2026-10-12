import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/catalog/controller/catalog_filter.dart';
import 'package:paddle_compare/app/catalog/view/catalog_view.dart';
import 'package:paddle_compare/app/router.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import '../helpers/fake_paddle_repository.dart';

final _everything = CatalogFilter(
  query: 'apex court',
  shapes: {PaddleShape.hybrid, PaddleShape.elongated},
  minPrice: 100,
  maxPrice: 200,
  inStockOnly: true,
  sort: PaddleSort.priceLowToHigh,
);

void main() {
  group('CatalogRoute.filter', () {
    test('is the default filter without parameters', () {
      expect(const CatalogRoute().filter, const CatalogFilter());
    });

    test('reads every parameter', () {
      const route = CatalogRoute(
        q: 'apex court',
        shape: ['hybrid', 'elongated'],
        minPrice: '100',
        maxPrice: '200',
        inStock: 'true',
        sort: 'price-asc',
      );

      expect(route.filter, _everything);
    });

    test('ignores unknown values', () {
      const route = CatalogRoute(
        shape: ['round', 'hybrid'],
        inStock: 'yes',
        sort: 'bogus',
      );

      expect(route.filter, CatalogFilter(shapes: {PaddleShape.hybrid}));
    });

    test('drops invalid prices', () {
      for (final price in ['abc', '', 'NaN', 'Infinity']) {
        final route = CatalogRoute(minPrice: price, maxPrice: price);

        expect(route.filter, const CatalogFilter(), reason: price);
      }
    });

    test('clamps prices to the bounds, where a bound means no limit', () {
      expect(
        const CatalogRoute(minPrice: '-50', maxPrice: '500').filter,
        const CatalogFilter(),
      );
      expect(
        const CatalogRoute(minPrice: '350').filter,
        const CatalogFilter(minPrice: CatalogFilter.priceBoundMax),
      );
    });

    test('swaps a min above the max', () {
      expect(
        const CatalogRoute(minPrice: '200', maxPrice: '100').filter,
        const CatalogFilter(minPrice: 100, maxPrice: 200),
      );
    });
  });

  group('CatalogRoute.fromFilter', () {
    test('turns the default filter into /', () {
      expect(CatalogRoute.fromFilter(const CatalogFilter()).location, '/');
    });

    test('writes every criterion, with shapes in a fixed order', () {
      expect(
        CatalogRoute.fromFilter(_everything).location,
        '/?q=apex+court&shape=hybrid&shape=elongated&min-price=100'
        '&max-price=200&in-stock=true&sort=price-asc',
      );
    });

    test('keeps decimals in prices', () {
      expect(
        CatalogRoute.fromFilter(const CatalogFilter(maxPrice: 99.5)).location,
        '/?max-price=99.5',
      );
    });

    test('round-trips through CatalogRoute.filter', () {
      for (final filter in [
        const CatalogFilter(),
        _everything,
        const CatalogFilter(query: ' spaces kept '),
        const CatalogFilter(maxPrice: 99.5),
        const CatalogFilter(sort: PaddleSort.power),
        const CatalogFilter(sort: PaddleSort.priceHighToLow),
      ]) {
        expect(CatalogRoute.fromFilter(filter).filter, filter);
      }
    });
  });

  testWidgets('the router reads the filter from the URL', (tester) async {
    tester.view.physicalSize = const Size(375, 812) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: $appRoutes,
      initialLocation: CatalogRoute.fromFilter(_everything).location,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paddleRepositoryProvider.overrideWithValue(FakePaddleRepository([])),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<CatalogView>(find.byType(CatalogView)).filter,
      _everything,
    );
  });
}
