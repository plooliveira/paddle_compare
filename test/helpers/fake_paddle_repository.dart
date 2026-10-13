import 'dart:async';

import 'package:paddle_compare/core/utils/result.dart';
import 'package:paddle_compare/data/api/in_memory_paddle_api.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_from_fake.dart';

/// Serves [paddles] through the real repository and an [InMemoryPaddleApi],
/// so queries run exactly like in the app, with no latency or failures.
class FakePaddleRepository implements PaddleRepository {
  FakePaddleRepository(this.paddles)
    : _repository = PaddleRepositoryFromFake(
        InMemoryPaddleApi([for (final paddle in paddles) _toJson(paddle)]),
      );

  final List<Paddle> paddles;
  final PaddleRepository _repository;

  /// When set, every request fails with it.
  Exception? error;

  /// When set, requests wait for it to complete before answering.
  Completer<void>? gate;

  final offsets = <int>[];
  final queries = <PaddleQuery>[];
  final ids = <String>[];

  @override
  Future<Result<List<Paddle>>> getPaddles({
    PaddleQuery query = const PaddleQuery(),
    int offset = 0,
    int? limit,
  }) async {
    offsets.add(offset);
    queries.add(query);
    if (gate case final gate?) await gate.future;
    if (error case final error?) return Result.error(error);
    return _repository.getPaddles(query: query, offset: offset, limit: limit);
  }

  @override
  Future<Result<Paddle?>> getPaddleById(String id) async {
    ids.add(id);
    if (gate case final gate?) await gate.future;
    if (error case final error?) return Result.error(error);
    return _repository.getPaddleById(id);
  }
}

/// The API's JSON for [paddle]. Parsing it gives [paddle] back.
Map<String, Object?> _toJson(Paddle paddle) => {
  'id': paddle.id,
  'brand': paddle.brand,
  'name': paddle.name,
  'releaseYear': ?paddle.releaseYear,
  'priceUsd': ?paddle.priceUsd,
  'inStock': ?paddle.inStock,
  'shape': ?paddle.shape?.name,
  'faceMaterial': ?paddle.faceMaterial,
  'coreThicknessMm': ?paddle.coreThicknessMm,
  if (paddle.weightOz case final weight?)
    'weight': {'value': weight, 'unit': 'oz'},
  'swingWeight': ?paddle.swingWeight,
  'twistWeight': ?paddle.twistWeight,
  'dimensionsIn': {
    'length': ?paddle.dimensions.lengthIn,
    'width': ?paddle.dimensions.widthIn,
    'handleLength': ?paddle.dimensions.handleLengthIn,
  },
  'gripCircumferenceIn': ?paddle.gripCircumferenceIn,
  'ratings': {
    'power': ?paddle.ratings.power,
    'control': ?paddle.ratings.control,
    'spin': ?paddle.ratings.spin,
    'pop': ?paddle.ratings.pop,
  },
  'imagePath': ?paddle.imagePath,
  'description': ?paddle.description,
};
