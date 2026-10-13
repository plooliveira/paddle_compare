import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../config/api_config.dart';
import 'in_memory_paddle_api.dart';
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
  Future<Map<String, dynamic>> fetchPaddles({
    String? search,
    List<String> shapes = const [],
    double? minPrice,
    double? maxPrice,
    bool inStockOnly = false,
    String? sort,
    int offset = 0,
    int? limit,
  }) async => (await _load()).fetchPaddles(
    search: search,
    shapes: shapes,
    minPrice: minPrice,
    maxPrice: maxPrice,
    inStockOnly: inStockOnly,
    sort: sort,
    offset: offset,
    limit: limit,
  );

  @override
  Future<Map<String, dynamic>?> fetchPaddle(String id) async =>
      (await _load()).fetchPaddle(id);

  Future<InMemoryPaddleApi> _load() async {
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

    if (decoded case {'paddles': final List<dynamic> items}) {
      return InMemoryPaddleApi(items);
    }
    throw const PaddleApiException('Unexpected response shape');
  }

  Duration _nextLatency() {
    final minMs = config.minLatency.inMilliseconds;
    final spread = max(0, config.maxLatency.inMilliseconds - minMs);
    return Duration(milliseconds: minMs + _random.nextInt(spread + 1));
  }
}
