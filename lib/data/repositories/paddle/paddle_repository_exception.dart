class PaddleRepositoryException implements Exception {
  const PaddleRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'PaddleRepositoryException: $message';
}
