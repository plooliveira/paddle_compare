import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/catalog/controller/catalog_filter.dart';
import 'package:paddle_compare/app/paddle_detail/view/paddle_detail_view.dart';
import 'package:paddle_compare/app/router.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../helpers/fake_paddle_repository.dart';
import '../helpers/pump_app.dart';

const _paddle = Paddle(id: 'summit', brand: 'Apex Court', name: 'Summit Pro');

double _backButtonOpacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find
          .ancestor(
            of: find.byType(BackButton),
            matching: find.byType(FadeTransition),
          )
          .first,
    )
    .opacity
    .value;

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
      expect(
        CatalogRoute.fromFilter(const CatalogFilter(), compare: []).location,
        '/',
      );
    });

    test('writes every criterion, with shapes in a fixed order', () {
      expect(
        CatalogRoute.fromFilter(_everything, compare: []).location,
        '/?q=apex+court&shape=hybrid&shape=elongated&min-price=100'
        '&max-price=200&in-stock=true&sort=price-asc',
      );
    });

    test('writes the paddles being compared last, in order', () {
      expect(
        CatalogRoute.fromFilter(_everything, compare: ['b', 'a']).location,
        '/?q=apex+court&shape=hybrid&shape=elongated&min-price=100'
        '&max-price=200&in-stock=true&sort=price-asc&compare=b&compare=a',
      );
      expect(
        CatalogRoute.fromFilter(
          const CatalogFilter(),
          compare: ['b', 'a'],
        ).location,
        '/?compare=b&compare=a',
      );
    });

    test('keeps decimals in prices', () {
      expect(
        CatalogRoute.fromFilter(
          const CatalogFilter(maxPrice: 99.5),
          compare: [],
        ).location,
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
        final route = CatalogRoute.fromFilter(filter, compare: ['b', 'a']);

        expect(route.filter, filter);
        expect(route.compareIds, ['b', 'a']);
      }
    });
  });

  group('CatalogRoute.compareIds', () {
    test('is empty without parameters', () {
      expect(const CatalogRoute().compareIds, isEmpty);
    });

    test('trims the ids and drops blanks and repeats', () {
      const route = CatalogRoute(compare: [' a ', '', '  ', 'b', 'a']);

      expect(route.compareIds, ['a', 'b']);
    });

    test('keeps at most three ids', () {
      const route = CatalogRoute(compare: ['a', 'b', 'c', 'd']);

      expect(route.compareIds, ['a', 'b', 'c']);
    });

    test('withCompare changes only the comparison', () {
      const route = CatalogRoute(q: 'apex', sort: 'power', compare: ['a']);

      expect(
        route.withCompare(['a', 'b']).location,
        '/?q=apex&sort=power&compare=a&compare=b',
      );
      expect(route.withCompare([]).location, '/?q=apex&sort=power');
    });
  });

  testWidgets('a detail link has the filtered catalog underneath', (
    tester,
  ) async {
    final router = await pumpApp(
      tester,
      FakePaddleRepository([_paddle]),
      location: '/paddles/summit?sort=price-asc',
    );
    await tester.pumpAndSettle();

    expect(find.text('Summit Pro'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailView), findsNothing);
    expect(find.text('Lowest price'), findsOneWidget);
    expect(currentUrl(router), '/?sort=price-asc');
  });

  testWidgets('the back button fades in while the detail page slides in', (
    tester,
  ) async {
    await pumpApp(tester, FakePaddleRepository([_paddle]));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View details'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(_backButtonOpacity(tester), allOf(greaterThan(0), lessThan(1)));

    await tester.pumpAndSettle();

    expect(_backButtonOpacity(tester), 1);
    expect(find.text('Summit Pro'), findsWidgets);
  });
}
