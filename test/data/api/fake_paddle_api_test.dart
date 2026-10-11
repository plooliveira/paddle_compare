import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/config/api_config.dart';
import 'package:paddle_compare/data/api/fake_paddle_api.dart';
import 'package:paddle_compare/data/api/paddle_api_exception.dart';

class _StringBundle extends CachingAssetBundle {
  _StringBundle(this.body);

  final String body;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(body.codeUnits));

  @override
  Future<String> loadString(String key, {bool cache = true}) async => body;
}

const _instant = ApiConfig(
  minLatency: Duration.zero,
  maxLatency: Duration.zero,
  failureRate: 0,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FakePaddleApi', () {
    test('returns the bundled paddles payload', () async {
      final api = FakePaddleApi(config: _instant);

      final json = await api.fetchPaddles();

      expect(json['paddles'], isA<List<dynamic>>());
      expect(json['paddles'], hasLength(32));
    });

    test('throws PaddleApiException when the request fails', () {
      final api = FakePaddleApi(
        config: const ApiConfig(
          minLatency: Duration.zero,
          maxLatency: Duration.zero,
          failureRate: 1,
        ),
      );

      expect(api.fetchPaddles(), throwsA(isA<PaddleApiException>()));
    });

    test('throws PaddleApiException on invalid JSON', () {
      final api = FakePaddleApi(
        bundle: _StringBundle('not json'),
        config: _instant,
      );

      expect(api.fetchPaddles(), throwsA(isA<PaddleApiException>()));
    });

    test('throws PaddleApiException when the payload is not an object', () {
      final api = FakePaddleApi(bundle: _StringBundle('[]'), config: _instant);

      expect(api.fetchPaddles(), throwsA(isA<PaddleApiException>()));
    });

    test('responds within the configured latency window', () {
      for (var seed = 0; seed < 20; seed++) {
        fakeAsync((async) {
          final api = FakePaddleApi(
            bundle: _StringBundle('{"paddles": []}'),
            random: Random(seed),
            config: const ApiConfig(failureRate: 0),
          );
          var done = false;
          api.fetchPaddles().then((_) => done = true);

          async.elapse(const Duration(milliseconds: 299));
          expect(done, isFalse, reason: 'seed $seed finished too early');

          async.elapse(const Duration(milliseconds: 501));
          expect(done, isTrue, reason: 'seed $seed finished too late');
        });
      }
    });
  });
}
