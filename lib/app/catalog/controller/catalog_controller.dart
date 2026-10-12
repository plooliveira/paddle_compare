import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../data/repositories/paddle/paddle_repository_provider.dart';
import 'catalog_filter.dart';
import '../state/catalog_state.dart';

part 'catalog_controller.g.dart';

/// The filter in the catalog URL. CatalogView overrides it for its subtree.
@Riverpod(dependencies: [])
CatalogFilter catalogFilter(Ref ref) => throw UnimplementedError();

Duration? _noRetry(int retryCount, Object error) => null;

/// Loads, page by page, the paddles matching the filter in the URL. A new
/// filter reloads from the first page.
@Riverpod(retry: _noRetry, dependencies: [catalogFilter])
class CatalogController extends _$CatalogController {
  static const pageSize = 12;

  @override
  Future<CatalogState> build() async {
    final query = ref.watch(
      catalogFilterProvider.select((filter) => filter.toQuery()),
    );
    final result = await ref
        .watch(paddleRepositoryProvider)
        .getPaddles(query: query, limit: pageSize);
    final page = switch (result) {
      Ok(:final value) => value,
      Error(:final error) => throw error,
    };
    return CatalogState(
      paddles: page,
      query: query,
      hasMore: page.length == pageSize,
    );
  }

  /// Reloads from the first page after the initial load failed.
  void retry() => ref.invalidateSelf();

  Future<void> loadMore() async {
    final current = switch (state) {
      AsyncData(:final value) when value.hasMore && !value.isLoadingMore =>
        value,
      _ => null,
    };
    if (current == null) return;

    // The notifier outlives rebuilds, but each build gets a new Ref. Checking
    // the captured one drops this page after a filter change or a retry(),
    // as well as a dispose.
    final requestRef = ref;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );
    final result = await ref
        .read(paddleRepositoryProvider)
        .getPaddles(
          query: current.query,
          offset: current.paddles.length,
          limit: pageSize,
        );
    if (!requestRef.mounted) return;

    final latest = state.requireValue;
    switch (result) {
      case Ok(:final value):
        state = AsyncData(
          latest.copyWith(
            paddles: List.unmodifiable([...latest.paddles, ...value]),
            hasMore: value.length == pageSize,
            isLoadingMore: false,
          ),
        );
      case Error(:final error):
        state = AsyncData(
          latest.copyWith(isLoadingMore: false, loadMoreError: error),
        );
    }
  }
}
