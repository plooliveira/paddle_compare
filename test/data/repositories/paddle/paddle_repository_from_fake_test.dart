import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/config/api_config.dart';
import 'package:paddle_compare/core/utils/result.dart';
import 'package:paddle_compare/data/api/fake_paddle_api.dart';
import 'package:paddle_compare/data/api/paddle_api.dart';
import 'package:paddle_compare/data/api/paddle_api_exception.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_from_fake.dart';

/// Answers with [response] and records what the repository asked for.
class _StubPaddleApi implements PaddleApi {
  _StubPaddleApi({this.response = const {}, this.error});

  final Map<String, dynamic> response;
  final Exception? error;

  /// The arguments of the last `fetchPaddles` call, by name.
  Map<String, Object?>? catalogRequest;
  final paddleRequests = <String>[];

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
    catalogRequest = {
      'search': search,
      'shapes': shapes,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'inStockOnly': inStockOnly,
      'sort': sort,
      'offset': offset,
      'limit': limit,
    };
    if (error case final error?) throw error;
    return response;
  }

  @override
  Future<Map<String, dynamic>?> fetchPaddle(String id) async {
    paddleRequests.add(id);
    if (error case final error?) throw error;
    for (final item in response['paddles'] as List) {
      if (item['id'] == id) return item;
    }
    return null;
  }
}

Map<String, Object?> _paddle(String id, {double? price}) => {
  'id': id,
  'brand': 'Brand',
  'name': 'Name $id',
  'priceUsd': ?price,
};

/// Reads the bundled paddles.json with no latency or failures.
PaddleRepositoryFromFake _bundledRepository() => PaddleRepositoryFromFake(
  FakePaddleApi(
    config: const ApiConfig(
      minLatency: Duration.zero,
      maxLatency: Duration.zero,
      failureRate: 0,
    ),
  ),
);

List<Paddle> _value(Result<List<Paddle>> result) => switch (result) {
  Ok<List<Paddle>>() => result.value,
  Error<List<Paddle>>() => fail('Expected Ok, got $result'),
};

Future<List<String>> _ids(PaddleRepository repository) async => [
  for (final paddle in _value(await repository.getPaddles())) paddle.id,
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PaddleRepositoryFromFake.getPaddles', () {
    test('forwards the query, offset and limit to the api', () async {
      final api = _StubPaddleApi(response: {'paddles': []});
      final repository = PaddleRepositoryFromFake(api);

      await repository.getPaddles(
        query: PaddleQuery(
          search: 'apex',
          shapes: {PaddleShape.hybrid, PaddleShape.widebody},
          minPrice: 100,
          maxPrice: 200,
          inStockOnly: true,
          sort: PaddleSort.priceHighToLow,
        ),
        offset: 12,
        limit: 12,
      );

      expect(api.catalogRequest, {
        'search': 'apex',
        'shapes': ['hybrid', 'widebody'],
        'minPrice': 100,
        'maxPrice': 200,
        'inStockOnly': true,
        'sort': PaddleApi.sortPriceDesc,
        'offset': 12,
        'limit': 12,
      });
      expect(api.paddleRequests, isEmpty);
    });

    test('sends each sort as its api value', () async {
      final api = _StubPaddleApi(response: {'paddles': []});
      final repository = PaddleRepositoryFromFake(api);

      Future<Object?> sentSort(PaddleSort sort) async {
        await repository.getPaddles(query: PaddleQuery(sort: sort));
        return api.catalogRequest?['sort'];
      }

      expect(await sentSort(PaddleSort.featured), isNull);
      expect(await sentSort(PaddleSort.priceLowToHigh), PaddleApi.sortPriceAsc);
      expect(
        await sentSort(PaddleSort.priceHighToLow),
        PaddleApi.sortPriceDesc,
      );
      expect(await sentSort(PaddleSort.power), PaddleApi.sortPower);
    });

    test('parses the page in the order the api sent it', () async {
      final repository = PaddleRepositoryFromFake(
        _StubPaddleApi(
          response: {
            'paddles': [_paddle('b', price: 99.5), _paddle('a')],
          },
        ),
      );

      final paddles = _value(await repository.getPaddles());

      expect(paddles.map((paddle) => paddle.id), ['b', 'a']);
      expect(paddles.first.priceUsd, 99.5);
    });

    test('skips entries it cannot parse', () async {
      final repository = PaddleRepositoryFromFake(
        _StubPaddleApi(
          response: {
            'paddles': [
              _paddle('a'),
              {'id': 'no-name'},
              'garbage',
              _paddle('b'),
            ],
          },
        ),
      );

      final paddles = _value(await repository.getPaddles());

      expect(paddles.map((paddle) => paddle.id), ['a', 'b']);
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
  });

  group('PaddleRepositoryFromFake.getPaddles over the bundled data', () {
    final repository = _bundledRepository();

    test('parses every paddle of paddles.json', () async {
      expect(await _ids(repository), hasLength(32));
    });
  });

  group('PaddleRepositoryFromFake.getPaddleById', () {
    late _StubPaddleApi api;
    late PaddleRepositoryFromFake repository;

    setUp(() {
      api = _StubPaddleApi(
        response: {
          'paddles': [
            _paddle('a'),
            _paddle('b'),
            {'id': 'no-name'},
          ],
        },
      );
      repository = PaddleRepositoryFromFake(api);
    });

    test('asks the api for that paddle only', () async {
      final result = await repository.getPaddleById('b');

      expect(result, isA<Ok<Paddle?>>());
      expect((result as Ok<Paddle?>).value?.id, 'b');
      expect(api.paddleRequests, ['b']);
      expect(api.catalogRequest, isNull);
    });

    test('returns Ok(null) for an unknown id', () async {
      final result = await repository.getPaddleById('missing');

      expect(result, isA<Ok<Paddle?>>());
      expect((result as Ok<Paddle?>).value, isNull);
    });

    test('returns Ok(null) for an entry it cannot parse', () async {
      final result = await repository.getPaddleById('no-name');

      expect(result, isA<Ok<Paddle?>>());
      expect((result as Ok<Paddle?>).value, isNull);
    });

    test('finds every paddle of the bundled catalog', () async {
      final repository = _bundledRepository();
      final paddles = _value(await repository.getPaddles());

      for (final paddle in paddles) {
        final result = await repository.getPaddleById(paddle.id);
        expect((result as Ok<Paddle?>).value, paddle);
      }
    });

    test('forwards api errors', () async {
      final failing = PaddleRepositoryFromFake(
        _StubPaddleApi(error: const PaddleApiException('down')),
      );

      expect(await failing.getPaddleById('a'), isA<Error<Paddle?>>());
    });
  });
}
