import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/data/api/in_memory_paddle_api.dart';
import 'package:paddle_compare/data/api/paddle_api.dart';

Map<String, Object?> _paddle(
  String id, {
  String brand = 'Brand',
  String? name,
  Object? price,
  String? shape,
  Object? inStock,
  Object? power,
}) => {
  'id': id,
  'brand': brand,
  'name': name ?? 'Name $id',
  'priceUsd': ?price,
  'shape': ?shape,
  'inStock': ?inStock,
  if (power != null) 'ratings': {'power': power},
};

Future<List<String>> _ids(
  PaddleApi api, {
  String? search,
  List<String> shapes = const [],
  double? minPrice,
  double? maxPrice,
  bool inStockOnly = false,
  String? sort,
  int offset = 0,
  int? limit,
}) async {
  final json = await api.fetchPaddles(
    search: search,
    shapes: shapes,
    minPrice: minPrice,
    maxPrice: maxPrice,
    inStockOnly: inStockOnly,
    sort: sort,
    offset: offset,
    limit: limit,
  );
  return [for (final item in json['paddles'] as List) item['id'] as String];
}

void main() {
  group('InMemoryPaddleApi.fetchPaddles', () {
    test('returns the entries as stored', () async {
      final entry = {..._paddle('a'), 'extra': 'kept'};
      final api = InMemoryPaddleApi([entry]);

      expect(await api.fetchPaddles(), {
        'paddles': [entry],
      });
    });

    test('skips invalid entries and duplicate ids', () async {
      final api = InMemoryPaddleApi([
        {'id': 'b', 'brand': 'Brand'},
        _paddle('a'),
        {'id': 'no-name'},
        'garbage',
        {..._paddle('a'), 'name': 'Duplicate'},
        _paddle('b'),
      ]);

      final json = await api.fetchPaddles();

      expect(await _ids(api), ['a', 'b']);
      expect((json['paddles'] as List).first['name'], 'Name a');
    });

    test('keeps the source order by default', () async {
      final api = InMemoryPaddleApi([
        _paddle('a', price: 300),
        _paddle('b', price: 100),
        _paddle('c', price: 200),
      ]);

      expect(await _ids(api), ['a', 'b', 'c']);
    });

    test('searches brand or name, ignoring case', () async {
      final api = InMemoryPaddleApi([
        _paddle('a', brand: 'Apex Court', name: 'Summit'),
        _paddle('b', brand: 'Dinkworks', name: 'Reset'),
        _paddle('c', brand: 'Other', name: 'Apex Clone'),
      ]);

      expect(await _ids(api, search: 'apex'), ['a', 'c']);
      expect(await _ids(api, search: 'RESET'), ['b']);
    });

    test('searches brand and name together, in any order', () async {
      final api = InMemoryPaddleApi([
        _paddle('a', brand: 'Apex Court', name: 'Summit'),
        _paddle('b', brand: 'Dinkworks', name: 'Reset'),
        _paddle('c', brand: 'Other', name: 'Apex Clone'),
      ]);

      Future<List<String>> search(String text) => _ids(api, search: text);

      expect(await search('apex summit'), ['a']);
      expect(await search('summit apex'), ['a']);
      expect(await search('apex  sum'), ['a']);
      expect(await search('apex clone'), ['c']);
      expect(await search('apex reset'), isEmpty);
    });

    test('filters by any requested shape, however it is spelled', () async {
      final api = InMemoryPaddleApi([
        _paddle('a', shape: 'standard'),
        _paddle('b', shape: 'hybrid'),
        _paddle('c', shape: ' Elongated '),
        _paddle('d', shape: 'Wide-Body'),
        _paddle('e', shape: 'teardrop'),
        _paddle('f'),
      ]);

      expect(await _ids(api, shapes: ['standard', 'elongated']), ['a', 'c']);
      expect(await _ids(api, shapes: ['widebody']), ['d']);
    });

    test(
      'filters by inclusive price bounds and drops unknown prices',
      () async {
        final api = InMemoryPaddleApi([
          _paddle('a', price: 99),
          _paddle('b', price: '150'),
          _paddle('c', price: 200),
          _paddle('d', price: 250),
          _paddle('e'),
          _paddle('f', price: 0),
        ]);

        expect(await _ids(api, minPrice: 150, maxPrice: 200), ['b', 'c']);
        expect(await _ids(api, minPrice: 200), ['c', 'd']);
        expect(await _ids(api, maxPrice: 100), ['a']);
      },
    );

    test('in stock only drops out-of-stock and unknown stock', () async {
      final api = InMemoryPaddleApi([
        _paddle('a', inStock: true),
        _paddle('b', inStock: false),
        _paddle('c'),
        _paddle('d', inStock: 'true'),
      ]);

      expect(await _ids(api, inStockOnly: true), ['a', 'd']);
    });

    test('combines every criterion', () async {
      final api = InMemoryPaddleApi([
        _paddle('a', brand: 'Apex', price: 150, shape: 'hybrid', inStock: true),
        _paddle(
          'b',
          brand: 'Apex',
          price: 150,
          shape: 'hybrid',
          inStock: false,
        ),
        _paddle('c', brand: 'Apex', price: 300, shape: 'hybrid', inStock: true),
        _paddle(
          'd',
          brand: 'Other',
          price: 150,
          shape: 'hybrid',
          inStock: true,
        ),
      ]);

      expect(
        await _ids(
          api,
          search: 'apex',
          shapes: ['hybrid'],
          maxPrice: 200,
          inStockOnly: true,
        ),
        ['a'],
      );
    });

    group('sort', () {
      final api = InMemoryPaddleApi([
        _paddle('a', price: 200, power: 5),
        _paddle('b', power: 9),
        _paddle('c', price: 100),
        _paddle('d', price: 200, power: 9),
        _paddle('e', price: 150, power: 7),
        _paddle('f', power: 11),
      ]);

      test('price low to high puts unknown prices last', () async {
        expect(await _ids(api, sort: PaddleApi.sortPriceAsc), [
          'c',
          'e',
          'a',
          'd',
          'b',
          'f',
        ]);
      });

      test('price high to low puts unknown prices last', () async {
        expect(await _ids(api, sort: PaddleApi.sortPriceDesc), [
          'a',
          'd',
          'e',
          'c',
          'b',
          'f',
        ]);
      });

      test('power puts the highest first and unknown ratings last', () async {
        expect(await _ids(api, sort: PaddleApi.sortPower), [
          'b',
          'd',
          'e',
          'a',
          'c',
          'f',
        ]);
      });

      test('an unknown sort keeps the source order', () async {
        expect(await _ids(api, sort: 'nope'), ['a', 'b', 'c', 'd', 'e', 'f']);
      });

      test('keeps the source order for ties', () async {
        final ids = 'abcdefghij'.split('');
        final tied = InMemoryPaddleApi([for (final id in ids) _paddle(id)]);

        expect(await _ids(tied, sort: PaddleApi.sortPriceAsc), ids);
      });
    });
  });

  group('InMemoryPaddleApi.fetchPaddles pages of a query', () {
    // Prices out of source order, with ties.
    final api = InMemoryPaddleApi([
      for (var i = 0; i < 25; i++)
        _paddle(
          'p$i',
          price: 50.0 + (i * 7 % 10) * 10,
          shape: i.isEven ? 'standard' : 'hybrid',
        ),
    ]);

    test(
      'sorted pages add up to the whole sorted list, without overlaps',
      () async {
        const sort = PaddleApi.sortPriceAsc;

        final pages = [
          for (var offset = 0; offset < 25; offset += 12)
            ...await _ids(api, sort: sort, offset: offset, limit: 12),
        ];

        expect(pages, await _ids(api, sort: sort));
        expect(pages.toSet(), hasLength(25));
      },
    );

    test('applies the offset after the filter', () async {
      expect(await _ids(api, shapes: ['hybrid'], offset: 2, limit: 2), [
        'p5',
        'p7',
      ]);
    });
  });

  group('InMemoryPaddleApi.fetchPaddles pagination', () {
    final api = InMemoryPaddleApi([
      _paddle('a'),
      {..._paddle('a'), 'name': 'Duplicate'},
      _paddle('b'),
      _paddle('c'),
      _paddle('d'),
    ]);

    test('returns the page at offset, after removing duplicates', () async {
      expect(await _ids(api, offset: 1, limit: 2), ['b', 'c']);
    });

    test('returns a short last page', () async {
      expect(await _ids(api, offset: 3, limit: 2), ['d']);
    });

    test('returns everything from offset when there is no limit', () async {
      expect(await _ids(api, offset: 2), ['c', 'd']);
    });

    test('returns an empty list for an offset past the end', () async {
      expect(await _ids(api, offset: 10, limit: 2), isEmpty);
    });
  });

  group('InMemoryPaddleApi.fetchPaddle', () {
    test('returns the entry with that id, as stored', () async {
      final api = InMemoryPaddleApi([_paddle('a'), _paddle('b')]);

      expect(await api.fetchPaddle('b'), _paddle('b'));
    });

    test('returns null for an unknown id', () async {
      final api = InMemoryPaddleApi([_paddle('a')]);

      expect(await api.fetchPaddle('missing'), isNull);
    });

    test('ignores whitespace around stored ids', () async {
      final api = InMemoryPaddleApi([_paddle(' a ')]);

      expect(await api.fetchPaddle('a'), _paddle(' a '));
    });

    test('returns the entry the catalog lists for a duplicate id', () async {
      final api = InMemoryPaddleApi([
        {'id': 'a'},
        _paddle('a'),
        {..._paddle('a'), 'name': 'Duplicate'},
      ]);

      expect(await api.fetchPaddle('a'), _paddle('a'));
    });
  });
}
