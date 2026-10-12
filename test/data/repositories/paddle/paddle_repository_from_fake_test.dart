import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/config/api_config.dart';
import 'package:paddle_compare/core/utils/result.dart';
import 'package:paddle_compare/data/api/fake_paddle_api.dart';
import 'package:paddle_compare/data/api/paddle_api.dart';
import 'package:paddle_compare/data/api/paddle_api_exception.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_from_fake.dart';

class _StubPaddleApi implements PaddleApi {
  _StubPaddleApi({this.response = const {}, this.error});

  final Map<String, dynamic> response;
  final Exception? error;

  @override
  Future<Map<String, dynamic>> fetchPaddles() async {
    if (error case final error?) throw error;
    return response;
  }
}

Map<String, Object?> _paddle(
  String id, {
  String brand = 'Brand',
  String? name,
  double? price,
  PaddleShape? shape,
  bool? inStock,
  int? power,
}) => {
  'id': id,
  'brand': brand,
  'name': name ?? 'Name $id',
  'priceUsd': ?price,
  'shape': ?shape?.name,
  'inStock': ?inStock,
  if (power != null) 'ratings': {'power': power},
};

PaddleRepositoryFromFake _repository(List<Map<String, Object?>> paddles) =>
    PaddleRepositoryFromFake(_StubPaddleApi(response: {'paddles': paddles}));

/// Reads the bundled paddles.json with no latency or failures.
PaddleRepositoryFromFake _bundledRepository() {
  TestWidgetsFlutterBinding.ensureInitialized();
  return PaddleRepositoryFromFake(
    FakePaddleApi(
      config: const ApiConfig(
        minLatency: Duration.zero,
        maxLatency: Duration.zero,
        failureRate: 0,
      ),
    ),
  );
}

List<Paddle> _value(Result<List<Paddle>> result) => switch (result) {
  Ok<List<Paddle>>() => result.value,
  Error<List<Paddle>>() => fail('Expected Ok, got $result'),
};

Future<List<String>> _ids(
  PaddleRepository repository, {
  PaddleQuery query = const PaddleQuery(),
  int offset = 0,
  int? limit,
}) async {
  final result = await repository.getPaddles(
    query: query,
    offset: offset,
    limit: limit,
  );
  return [for (final paddle in _value(result)) paddle.id];
}

void main() {
  group('PaddleRepositoryFromFake.getPaddles', () {
    test('returns parsed paddles', () async {
      final repository = PaddleRepositoryFromFake(
        _StubPaddleApi(
          response: {
            'paddles': [_paddle('a'), _paddle('b')],
          },
        ),
      );

      final paddles = _value(await repository.getPaddles());

      expect(paddles.map((paddle) => paddle.id), ['a', 'b']);
    });

    test('skips invalid entries and duplicate ids', () async {
      final repository = PaddleRepositoryFromFake(
        _StubPaddleApi(
          response: {
            'paddles': [
              _paddle('a'),
              {'id': 'no-name'},
              'garbage',
              {..._paddle('a'), 'name': 'Duplicate'},
              _paddle('b'),
            ],
          },
        ),
      );

      final paddles = _value(await repository.getPaddles());

      expect(paddles.map((paddle) => paddle.id), ['a', 'b']);
      expect(paddles.first.name, 'Name a');
    });

    test('returns an error when the payload has no paddle list', () async {
      final repository = PaddleRepositoryFromFake(
        _StubPaddleApi(response: {'paddles': 'nope'}),
      );

      final result = await repository.getPaddles();

      expect(result, isA<Error<List<Paddle>>>());
      expect(
        (result as Error<List<Paddle>>).error,
        isA<PaddleRepositoryException>(),
      );
    });

    test('returns an error when the api fails', () async {
      const exception = PaddleApiException('Network request failed');
      final repository = PaddleRepositoryFromFake(
        _StubPaddleApi(error: exception),
      );

      final result = await repository.getPaddles();

      expect(result, isA<Error<List<Paddle>>>());
      expect((result as Error<List<Paddle>>).error, exception);
    });

    test('parses the bundled paddles.json', () async {
      final paddles = _value(await _bundledRepository().getPaddles());

      expect(paddles, hasLength(32));
    });
  });

  group('PaddleRepositoryFromFake.getPaddles query', () {
    test('keeps the source order by default', () async {
      final repository = _repository([
        _paddle('a', price: 300),
        _paddle('b', price: 100),
        _paddle('c', price: 200),
      ]);

      expect(await _ids(repository), ['a', 'b', 'c']);
    });

    test('searches brand or name, ignoring case', () async {
      final repository = _repository([
        _paddle('a', brand: 'Apex Court', name: 'Summit'),
        _paddle('b', brand: 'Dinkworks', name: 'Reset'),
        _paddle('c', brand: 'Other', name: 'Apex Clone'),
      ]);

      expect(await _ids(repository, query: const PaddleQuery(search: 'apex')), [
        'a',
        'c',
      ]);
      expect(
        await _ids(repository, query: const PaddleQuery(search: 'RESET')),
        ['b'],
      );
    });

    test('searches brand and name together, in any order', () async {
      final repository = _repository([
        _paddle('a', brand: 'Apex Court', name: 'Summit'),
        _paddle('b', brand: 'Dinkworks', name: 'Reset'),
        _paddle('c', brand: 'Other', name: 'Apex Clone'),
      ]);

      Future<List<String>> search(String text) =>
          _ids(repository, query: PaddleQuery(search: text));

      expect(await search('apex summit'), ['a']);
      expect(await search('summit apex'), ['a']);
      expect(await search('apex  sum'), ['a']);
      expect(await search('apex clone'), ['c']);
      expect(await search('apex reset'), isEmpty);
    });

    test('filters by any selected shape and drops unknown shapes', () async {
      final repository = _repository([
        _paddle('a', shape: PaddleShape.standard),
        _paddle('b', shape: PaddleShape.hybrid),
        _paddle('c', shape: PaddleShape.elongated),
        _paddle('d'),
      ]);

      final query = PaddleQuery(
        shapes: {PaddleShape.standard, PaddleShape.elongated},
      );

      expect(await _ids(repository, query: query), ['a', 'c']);
    });

    test(
      'filters by inclusive price bounds and drops unknown prices',
      () async {
        final repository = _repository([
          _paddle('a', price: 99),
          _paddle('b', price: 150),
          _paddle('c', price: 200),
          _paddle('d', price: 250),
          _paddle('e'),
        ]);

        expect(
          await _ids(
            repository,
            query: const PaddleQuery(minPrice: 150, maxPrice: 200),
          ),
          ['b', 'c'],
        );
        expect(
          await _ids(repository, query: const PaddleQuery(minPrice: 200)),
          ['c', 'd'],
        );
        expect(
          await _ids(repository, query: const PaddleQuery(maxPrice: 100)),
          ['a'],
        );
      },
    );

    test('in stock only drops out-of-stock and unknown stock', () async {
      final repository = _repository([
        _paddle('a', inStock: true),
        _paddle('b', inStock: false),
        _paddle('c'),
      ]);

      expect(
        await _ids(repository, query: const PaddleQuery(inStockOnly: true)),
        ['a'],
      );
    });

    test('combines every criterion', () async {
      final repository = _repository([
        _paddle(
          'a',
          brand: 'Apex',
          price: 150,
          shape: PaddleShape.hybrid,
          inStock: true,
        ),
        _paddle(
          'b',
          brand: 'Apex',
          price: 150,
          shape: PaddleShape.hybrid,
          inStock: false,
        ),
        _paddle(
          'c',
          brand: 'Apex',
          price: 300,
          shape: PaddleShape.hybrid,
          inStock: true,
        ),
        _paddle(
          'd',
          brand: 'Other',
          price: 150,
          shape: PaddleShape.hybrid,
          inStock: true,
        ),
      ]);

      final query = PaddleQuery(
        search: 'apex',
        shapes: {PaddleShape.hybrid},
        maxPrice: 200,
        inStockOnly: true,
      );

      expect(await _ids(repository, query: query), ['a']);
    });

    group('sort', () {
      final repository = _repository([
        _paddle('a', price: 200, power: 5),
        _paddle('b', power: 9),
        _paddle('c', price: 100),
        _paddle('d', price: 200, power: 9),
        _paddle('e', price: 150, power: 7),
      ]);

      test('price low to high puts unknown prices last', () async {
        const query = PaddleQuery(sort: PaddleSort.priceLowToHigh);

        expect(await _ids(repository, query: query), ['c', 'e', 'a', 'd', 'b']);
      });

      test('price high to low puts unknown prices last', () async {
        const query = PaddleQuery(sort: PaddleSort.priceHighToLow);

        expect(await _ids(repository, query: query), ['a', 'd', 'e', 'c', 'b']);
      });

      test('power puts the highest first and unknown ratings last', () async {
        const query = PaddleQuery(sort: PaddleSort.power);

        expect(await _ids(repository, query: query), ['b', 'd', 'e', 'a', 'c']);
      });

      test('keeps the source order for ties', () async {
        final ids = 'abcdefghij'.split('');
        final tied = _repository([for (final id in ids) _paddle(id)]);
        const query = PaddleQuery(sort: PaddleSort.priceLowToHigh);

        expect(await _ids(tied, query: query), ids);
      });
    });
  });

  group('PaddleRepositoryFromFake.getPaddles pages of a query', () {
    // Prices out of source order, with ties.
    final repository = _repository([
      for (var i = 0; i < 25; i++)
        _paddle(
          'p$i',
          price: 50.0 + (i * 7 % 10) * 10,
          shape: i.isEven ? PaddleShape.standard : PaddleShape.hybrid,
        ),
    ]);

    test(
      'sorted pages add up to the whole sorted list, without overlaps',
      () async {
        const query = PaddleQuery(sort: PaddleSort.priceLowToHigh);

        final pages = [
          for (var offset = 0; offset < 25; offset += 12)
            ...await _ids(repository, query: query, offset: offset, limit: 12),
        ];

        expect(pages, await _ids(repository, query: query));
        expect(pages.toSet(), hasLength(25));
      },
    );

    test('applies the offset after the filter', () async {
      final query = PaddleQuery(shapes: {PaddleShape.hybrid});

      expect(await _ids(repository, query: query, offset: 2, limit: 2), [
        'p5',
        'p7',
      ]);
    });
  });

  group(
    'PaddleRepositoryFromFake.getPaddles first page of the bundled data',
    () {
      final repository = _bundledRepository();

      test('by lowest price starts with the cheapest paddle', () async {
        final ids = await _ids(
          repository,
          query: const PaddleQuery(sort: PaddleSort.priceLowToHigh),
          limit: 12,
        );

        expect(ids.first, 'third-shot-labs-practice-pal');
      });

      test('by power starts with both paddles rated 9', () async {
        final ids = await _ids(
          repository,
          query: const PaddleQuery(sort: PaddleSort.power),
          limit: 12,
        );

        expect(ids.take(2), [
          'third-shot-labs-drive-shot-elongated',
          'erne-athletics-airborne-14',
        ]);
      });
    },
  );

  group('PaddleRepositoryFromFake.getPaddles pagination', () {
    final repository = PaddleRepositoryFromFake(
      _StubPaddleApi(
        response: {
          'paddles': [
            _paddle('a'),
            {..._paddle('a'), 'name': 'Duplicate'},
            _paddle('b'),
            _paddle('c'),
            _paddle('d'),
          ],
        },
      ),
    );

    test('returns the page at offset, after removing duplicates', () async {
      final paddles = _value(await repository.getPaddles(offset: 1, limit: 2));

      expect(paddles.map((paddle) => paddle.id), ['b', 'c']);
    });

    test('returns a short last page', () async {
      final paddles = _value(await repository.getPaddles(offset: 3, limit: 2));

      expect(paddles.map((paddle) => paddle.id), ['d']);
    });

    test('returns everything from offset when there is no limit', () async {
      final paddles = _value(await repository.getPaddles(offset: 2));

      expect(paddles.map((paddle) => paddle.id), ['c', 'd']);
    });

    test('returns an empty list for an offset past the end', () async {
      expect(
        _value(await repository.getPaddles(offset: 10, limit: 2)),
        isEmpty,
      );
    });
  });

  group('PaddleRepositoryFromFake.getPaddleById', () {
    final repository = PaddleRepositoryFromFake(
      _StubPaddleApi(
        response: {
          'paddles': [_paddle('a'), _paddle('b')],
        },
      ),
    );

    test('returns the matching paddle', () async {
      final result = await repository.getPaddleById('b');

      expect(result, isA<Ok<Paddle?>>());
      expect((result as Ok<Paddle?>).value?.id, 'b');
    });

    test('returns Ok(null) for an unknown id', () async {
      final result = await repository.getPaddleById('missing');

      expect(result, isA<Ok<Paddle?>>());
      expect((result as Ok<Paddle?>).value, isNull);
    });

    test('forwards api errors', () async {
      final failing = PaddleRepositoryFromFake(
        _StubPaddleApi(error: const PaddleApiException('down')),
      );

      expect(await failing.getPaddleById('a'), isA<Error<Paddle?>>());
    });
  });
}
