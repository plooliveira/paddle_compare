import 'models/paddle.dart';
import 'models/paddle_query.dart';
import 'models/paddle_sort.dart';

/// Runs a [PaddleQuery] over a full list, the way a server would. Internal to
/// this module: the contract does not export it.
extension PaddleQueryInMemory on PaddleQuery {
  /// The paddles that match, sorted. Ties keep the order of [paddles].
  List<Paddle> apply(Iterable<Paddle> paddles) {
    final needle = search?.toLowerCase() ?? '';
    final matches = [
      for (final (index, paddle) in paddles.indexed)
        if (_matches(paddle, needle)) (index, paddle),
    ];
    if (sort != PaddleSort.featured) {
      // List.sort is not stable, so ties fall back to the source order.
      matches.sort((a, b) {
        final bySort = _compare(a.$2, b.$2);
        return bySort != 0 ? bySort : a.$1.compareTo(b.$1);
      });
    }
    return List.unmodifiable(matches.map((match) => match.$2));
  }

  bool _matches(Paddle paddle, String needle) {
    if (needle.isNotEmpty &&
        !paddle.brand.toLowerCase().contains(needle) &&
        !paddle.name.toLowerCase().contains(needle)) {
      return false;
    }
    if (shapes.isNotEmpty && !shapes.contains(paddle.shape)) return false;
    if (minPrice != null || maxPrice != null) {
      final price = paddle.priceUsd;
      if (price == null) return false;
      if (minPrice case final min? when price < min) return false;
      if (maxPrice case final max? when price > max) return false;
    }
    if (inStockOnly && paddle.inStock != true) return false;
    return true;
  }

  int _compare(Paddle a, Paddle b) => switch (sort) {
    PaddleSort.featured => 0,
    PaddleSort.priceLowToHigh => _nullsLast(a.priceUsd, b.priceUsd),
    PaddleSort.priceHighToLow => _nullsLast(
      a.priceUsd,
      b.priceUsd,
      descending: true,
    ),
    PaddleSort.power => _nullsLast(
      a.ratings.power,
      b.ratings.power,
      descending: true,
    ),
  };
}

/// Nulls go last in both directions.
int _nullsLast(num? a, num? b, {bool descending = false}) {
  if (a == null || b == null) {
    if (a == b) return 0;
    return a == null ? 1 : -1;
  }
  return descending ? b.compareTo(a) : a.compareTo(b);
}
