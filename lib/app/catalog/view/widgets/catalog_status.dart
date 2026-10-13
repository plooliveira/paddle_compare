import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/catalog_state.dart';

/// What the catalog's results area shows.
enum CatalogStatus {
  loading,
  refreshing,
  error,
  ready;

  static CatalogStatus from(AsyncValue<CatalogState> state) => switch (state) {
    AsyncValue(isLoading: true, hasValue: true, hasError: false) => refreshing,
    AsyncValue(isLoading: true) => loading,
    AsyncValue(hasError: true) => error,
    _ => ready,
  };
}
