import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../config/api_config.dart';
import 'paddle_api.dart';
import 'paddle_api_exception.dart';

class FakePaddleApi implements PaddleApi {
  FakePaddleApi({
    AssetBundle? bundle,
    Random? random,
    this.config = const ApiConfig(),
    this.assetPath = 'assets/data/paddles.json',
  }) : _bundle = bundle ?? rootBundle,
       _random = random ?? Random();

  final AssetBundle _bundle;
  final Random _random;
  final ApiConfig config;
  final String assetPath;

  @override
  Future<Map<String, dynamic>> fetchPaddles() async {
    await Future<void>.delayed(_nextLatency());

    if (_random.nextDouble() < config.failureRate) {
      throw const PaddleApiException('Network request failed');
    }

    final String raw;
    try {
      raw = await _bundle.loadString(assetPath);
    } catch (e) {
      throw PaddleApiException('Could not load $assetPath', cause: e);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (e) {
      throw PaddleApiException('Response is not valid JSON', cause: e);
    }

    if (decoded is! Map<String, dynamic>) {
      throw const PaddleApiException('Unexpected response shape');
    }
    return decoded;
  }

  Duration _nextLatency() {
    final minMs = config.minLatency.inMilliseconds;
    final spread = max(0, config.maxLatency.inMilliseconds - minMs);
    return Duration(milliseconds: minMs + _random.nextInt(spread + 1));
  }
}
