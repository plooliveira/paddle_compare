import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/core/utils/result.dart';

String describe(Result<int> result) => switch (result) {
  Ok<int>() => 'ok ${result.value}',
  Error<int>() => 'error ${result.error}',
};

void main() {
  test('Result.ok carries the value', () {
    const result = Result.ok(42);

    expect(result, isA<Ok<int>>());
    expect(describe(result), 'ok 42');
    expect(result.toString(), 'Result<int>.ok(42)');
  });

  test('Result.error carries the exception', () {
    final exception = Exception('boom');
    final result = Result<int>.error(exception);

    expect(result, isA<Error<int>>());
    expect(describe(result), 'error $exception');
    expect(result.toString(), 'Result<int>.error($exception)');
  });
}
