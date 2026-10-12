import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/app/catalog/controller/catalog_filter.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

void main() {
  group('CatalogFilter.toQuery', () {
    test('carries every criterion over', () {
      final filter = CatalogFilter(
        query: 'apex',
        shapes: {PaddleShape.hybrid},
        minPrice: 100,
        maxPrice: 200,
        inStockOnly: true,
        sort: PaddleSort.power,
      );

      expect(
        filter.toQuery(),
        PaddleQuery(
          search: 'apex',
          shapes: {PaddleShape.hybrid},
          minPrice: 100,
          maxPrice: 200,
          inStockOnly: true,
          sort: PaddleSort.power,
        ),
      );
    });

    test('trims the search', () {
      expect(const CatalogFilter(query: '  apex ').toQuery().search, 'apex');
    });

    test('turns a blank search into null', () {
      expect(const CatalogFilter().toQuery().search, isNull);
      expect(const CatalogFilter(query: '   ').toQuery().search, isNull);
    });
  });

  group('CatalogFilter.toggleShape', () {
    test('adds a shape, and removes it the second time', () {
      final added = const CatalogFilter().toggleShape(PaddleShape.hybrid);
      expect(added.shapes, {PaddleShape.hybrid});

      expect(added.toggleShape(PaddleShape.hybrid).shapes, isEmpty);
    });

    test('keeps the other shapes', () {
      final filter = CatalogFilter(shapes: {PaddleShape.standard});

      expect(filter.toggleShape(PaddleShape.hybrid).shapes, {
        PaddleShape.standard,
        PaddleShape.hybrid,
      });
    });
  });

  group('CatalogFilter.cleared and reset', () {
    final filter = CatalogFilter(
      query: 'apex',
      shapes: {PaddleShape.hybrid},
      minPrice: 100,
      maxPrice: 200,
      inStockOnly: true,
      sort: PaddleSort.priceHighToLow,
    );

    test('cleared keeps only the sort', () {
      expect(
        filter.cleared(),
        const CatalogFilter(sort: PaddleSort.priceHighToLow),
      );
    });

    test('reset keeps the search and the sort', () {
      expect(
        filter.reset(),
        const CatalogFilter(query: 'apex', sort: PaddleSort.priceHighToLow),
      );
    });
  });

  group('CatalogFilter.activeFilterCount', () {
    test('is zero by default and ignores search and sort', () {
      expect(const CatalogFilter().activeFilterCount, 0);
      expect(
        const CatalogFilter(
          query: 'x',
          sort: PaddleSort.power,
        ).activeFilterCount,
        0,
      );
    });

    test('counts each shape, the price range and stock', () {
      expect(
        CatalogFilter(shapes: {PaddleShape.standard, PaddleShape.hybrid})
            .activeFilterCount,
        2,
      );
      expect(const CatalogFilter(minPrice: 10).activeFilterCount, 1);
      expect(
        const CatalogFilter(minPrice: 10, maxPrice: 20).activeFilterCount,
        1,
      );
      expect(
        CatalogFilter(
          shapes: {PaddleShape.widebody},
          maxPrice: 20,
          inStockOnly: true,
        ).activeFilterCount,
        3,
      );
    });
  });
}
