import '../../core/utils/json_readers.dart';
import 'paddle_api.dart';

class InMemoryPaddleApi implements PaddleApi {
  /// Keeps the entries of [items] that make a paddle, the first one per id,
  /// in source order. That order is the server's default.
  InMemoryPaddleApi(Iterable<Object?> items) : _entries = _catalog(items);

  final List<_Entry> _entries;

  @override
  Future<Map<String, dynamic>> fetchPaddles({
    String? search,
    List<String> shapes = const [],
    double? minPrice,
    double? maxPrice,
    bool inStockOnly = false,
    String? sort,
    int offset = 0,
    int? limit,
  }) async {
    assert(offset >= 0 && (limit == null || limit >= 0));
    final terms = [
      for (final term in (search ?? '').toLowerCase().split(RegExp(r'\s+')))
        if (term.isNotEmpty) term,
    ];

    bool matches(_Entry entry) {
      if (!terms.every(entry.brandAndName.contains)) return false;
      if (shapes.isNotEmpty && !shapes.contains(entry.shape)) return false;
      if (minPrice != null || maxPrice != null) {
        final price = entry.price;
        if (price == null) return false;
        if (minPrice != null && price < minPrice) return false;
        if (maxPrice != null && price > maxPrice) return false;
      }
      if (inStockOnly && entry.inStock != true) return false;
      return true;
    }

    final results = [
      for (final (index, entry) in _entries.indexed)
        if (matches(entry)) (index, entry),
    ];
    if (_comparator(sort) case final compare?) {
      // List.sort is not stable, so ties fall back to the source order.
      results.sort((a, b) {
        final bySort = compare(a.$2, b.$2);
        return bySort != 0 ? bySort : a.$1.compareTo(b.$1);
      });
    }
    final page = results.skip(offset).map((result) => result.$2.json);
    return {'paddles': (limit == null ? page : page.take(limit)).toList()};
  }

  @override
  Future<Map<String, dynamic>?> fetchPaddle(String id) async {
    for (final entry in _entries) {
      if (entry.id == id) return entry.json;
    }
    return null;
  }
}

List<_Entry> _catalog(Iterable<Object?> items) {
  final entriesById = <String, _Entry>{};
  for (final item in items) {
    if (_Entry.tryRead(item) case final entry?) {
      entriesById.putIfAbsent(entry.id, () => entry);
    }
  }
  return List.unmodifiable(entriesById.values);
}

int Function(_Entry, _Entry)? _comparator(String? sort) => switch (sort) {
  PaddleApi.sortPriceAsc => (a, b) => _nullsLast(a.price, b.price),
  PaddleApi.sortPriceDesc => (a, b) => _nullsLast(
    a.price,
    b.price,
    descending: true,
  ),
  PaddleApi.sortPower => (a, b) => _nullsLast(
    a.power,
    b.power,
    descending: true,
  ),
  _ => null,
};

/// Nulls go last in both directions.
int _nullsLast(num? a, num? b, {bool descending = false}) {
  if (a == null || b == null) {
    if (a == b) return 0;
    return a == null ? 1 : -1;
  }
  return descending ? b.compareTo(a) : a.compareTo(b);
}

/// What the server reads from a raw entry to match and sort it. It follows
/// the app's parsing rules (`Paddle.tryFromJson`), so both agree on which
/// entries are paddles and which ones have a price, a shape or a rating.
class _Entry {
  const _Entry(
    this.json, {
    required this.id,
    required this.brandAndName,
    this.price,
    this.inStock,
    this.shape,
    this.power,
  });

  static _Entry? tryRead(Object? item) {
    if (item is! Map<String, dynamic>) return null;
    final id = readString(item['id']);
    final brand = readString(item['brand']);
    final name = readString(item['name']);
    if (id == null || brand == null || name == null) return null;

    final price = readDouble(item['priceUsd']);
    final power = readInt(readMap(item['ratings'])?['power']);
    return _Entry(
      item,
      id: id,
      brandAndName: '$brand $name'.toLowerCase(),
      price: price != null && price > 0 ? price : null,
      inStock: readBool(item['inStock']),
      shape: readToken(item['shape']),
      power: power != null && power >= 0 && power <= 10 ? power : null,
    );
  }

  final Map<String, dynamic> json;
  final String id;
  final String brandAndName;
  final double? price;
  final bool? inStock;
  final String? shape;
  final int? power;
}
