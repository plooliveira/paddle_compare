import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repositories/paddle/paddle_repository.dart';

part 'catalog_state.freezed.dart';

@freezed
abstract class CatalogState with _$CatalogState {
  const factory CatalogState({
    required List<Paddle> paddles,
    required PaddleQuery query,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
    Object? loadMoreError,
  }) = _CatalogState;
}
