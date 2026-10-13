abstract interface class PaddleApi {
  /// Values for `fetchPaddles(sort:)`. Null, or any other value, keeps the
  /// server's default order.
  static const sortPriceAsc = 'price-asc';
  static const sortPriceDesc = 'price-desc';
  static const sortPower = 'power';

  /// `GET /paddles`: `{"paddles": [...]}` with the paddles that match, in
  /// [sort] order, starting at [offset]. Ties keep the server's order, so
  /// consecutive pages of the same query never overlap.
  ///
  /// Every term of [search] must appear in the brand or the name, ignoring
  /// case. [shapes] holds shape names (`hybrid`); empty means every shape.
  /// The price bounds are inclusive. A paddle without the data an active
  /// filter needs is left out, and goes last when the sort needs it.
  Future<Map<String, dynamic>> fetchPaddles({
    String? search,
    List<String> shapes = const [],
    double? minPrice,
    double? maxPrice,
    bool inStockOnly = false,
    String? sort,
    int offset = 0,
    int? limit,
  });

  /// `GET /paddles/:id`: the raw paddle whose id is [id], or null when there
  /// is none (a 404).
  Future<Map<String, dynamic>?> fetchPaddle(String id);
}
