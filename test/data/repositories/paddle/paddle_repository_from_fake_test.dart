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

Map<String, Object?> _paddle(String id) => {
  'id': id,
  'brand': 'Brand',
  'name': 'Name $id',
};

List<Paddle> _value(Result<List<Paddle>> result) => switch (result) {
  Ok<List<Paddle>>() => result.value,
  Error<List<Paddle>>() => fail('Expected Ok, got $result'),
};

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
      TestWidgetsFlutterBinding.ensureInitialized();
      final repository = PaddleRepositoryFromFake(
        FakePaddleApi(
          config: const ApiConfig(
            minLatency: Duration.zero,
            maxLatency: Duration.zero,
            failureRate: 0,
          ),
        ),
      );

      final paddles = _value(await repository.getPaddles());

      expect(paddles, hasLength(32));
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
