import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../controller/catalog_filter.dart';

extension PaddleSortLabel on PaddleSort {
  String get label => switch (this) {
    PaddleSort.featured => 'Featured',
    PaddleSort.priceLowToHigh => 'Price: Low to High',
    PaddleSort.priceHighToLow => 'Price: High to Low',
    PaddleSort.power => 'Power: High to Low',
  };

  /// Fits the toolbar button.
  String get shortLabel => switch (this) {
    PaddleSort.featured => 'Sort',
    PaddleSort.priceLowToHigh => 'Lowest price',
    PaddleSort.priceHighToLow => 'Highest price',
    PaddleSort.power => 'Most power',
  };
}

/// `$100 – $200`, `$100+`, `Up to $200`, or `Any price` when both are null.
String priceRangeLabel(double? min, double? max) {
  String dollars(double value) => '\$${value.round()}';
  return switch ((min, max)) {
    (null, null) => 'Any price',
    (final min?, null) => '${dollars(min)}+',
    (null, final max?) => 'Up to ${dollars(max)}',
    (final min?, final max?) => '${dollars(min)} – ${dollars(max)}',
  };
}

String paddleCountLabel(int count) =>
    count == 1 ? '1 paddle' : '$count paddles';

extension CatalogFilterPriceRange on CatalogFilter {
  String get priceLabel => priceRangeLabel(minPrice, maxPrice);
}
