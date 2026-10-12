import 'dart:async';

import 'package:paddle_compare/core/utils/result.dart';
// Test-only exception to "outside the module, only the contract": the fake
// runs queries the same way as the real repository instead of duplicating it.
import 'package:paddle_compare/data/repositories/paddle/paddle_query_in_memory.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

class FakePaddleRepository implements PaddleRepository {
  FakePaddleRepository(this.paddles);

  final List<Paddle> paddles;

  /// When set, every request fails with it.
  Exception? error;

  /// When set, requests wait for it to complete before answering.
  Completer<void>? gate;

  final offsets = <int>[];
  final queries = <PaddleQuery>[];

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
    final page = query.apply(paddles).skip(offset);
    return Result.ok((limit == null ? page : page.take(limit)).toList());
  }

  @override
  Future<Result<Paddle?>> getPaddleById(String id) =>
      throw UnimplementedError();
}
