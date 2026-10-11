class PaddleApiException implements Exception {
  const PaddleApiException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null
      ? 'PaddleApiException: $message'
      : 'PaddleApiException: $message ($cause)';
}
