import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repositories/paddle/paddle_repository.dart';

part 'catalog_state.freezed.dart';

@freezed
abstract class CatalogState with _$CatalogState {
  const factory CatalogState({
    /// Every page loaded so far for [query], in the order the server
    /// returned them.
    required List<Paddle> paddles,
    required PaddleQuery query,
    required bool hasMore,
    @Default(false) bool isLoadingMore,

    /// Set when loading the next page failed. The loaded pages are kept.
    Object? loadMoreError,
  }) = _CatalogState;
}
