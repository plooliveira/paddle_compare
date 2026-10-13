import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../controller/catalog_controller.dart';
import '../../state/catalog_state.dart';
import 'catalog_labels.dart';

String _countLabel(AsyncValue<CatalogState> state) => switch (state) {
  AsyncValue(isLoading: true) => 'Loading…',
  AsyncValue(hasError: true) => '',
  AsyncValue(:final value?) when value.hasMore =>
    '${value.paddles.length}+ paddles',
  AsyncValue(:final value?) => paddleCountLabel(value.paddles.length),
  _ => '',
};

class CatalogResultCount extends ConsumerStatefulWidget {
  const CatalogResultCount({super.key});

  @override
  ConsumerState<CatalogResultCount> createState() => _CatalogResultCountState();
}

class _CatalogResultCountState extends ConsumerState<CatalogResultCount> {
  static const _announceDelay = Duration(seconds: 1);

  Timer? _announceTimer;

  @override
  void dispose() {
    _announceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only a finished load of a new query is announced: a new page keeps the
    // query, and a load in progress drops any pending announcement.
    ref.listen(
      catalogControllerProvider.select(
        (state) => switch (state) {
          AsyncData(isLoading: false, :final value) => value.query,
          _ => null,
        },
      ),
      (_, query) {
        _announceTimer?.cancel();
        if (query == null) return;
        _announceTimer = Timer(_announceDelay, () {
          SemanticsService.sendAnnouncement(
            View.of(context),
            _countLabel(ref.read(catalogControllerProvider)),
            Directionality.of(context),
          );
        });
      },
    );
    final label = ref.watch(catalogControllerProvider.select(_countLabel));
    final theme = Theme.of(context);

    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
