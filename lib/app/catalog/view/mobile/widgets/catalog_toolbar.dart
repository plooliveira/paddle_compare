import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../controller/catalog_controller.dart';
import '../../../state/catalog_state.dart';
import '../../widgets/catalog_labels.dart';

class CatalogToolbar extends ConsumerWidget {
  const CatalogToolbar({
    super.key,
    required this.onFilter,
    required this.onSort,
  });

  final VoidCallback onFilter;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:activeFilters, :sort) = ref.watch(
      catalogFilterProvider.select(
        (filter) =>
            (activeFilters: filter.activeFilterCount, sort: filter.sort),
      ),
    );

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 4,
      children: [
        const _ResultCount(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToolbarButton(
              icon: Icons.tune,
              label: 'Filter',
              badgeCount: activeFilters,
              onPressed: onFilter,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: _ToolbarButton(
                icon: Icons.swap_vert,
                label: sort.shortLabel,
                semanticsLabel: 'Sort by ${sort.label}',
                onPressed: onSort,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _countLabel(AsyncValue<CatalogState> state) => switch (state) {
  AsyncValue(isLoading: true) => 'Loading…',
  AsyncValue(hasError: true) => '',
  AsyncValue(:final value?) when value.hasMore =>
    '${value.paddles.length}+ paddles',
  AsyncValue(:final value?) => paddleCountLabel(value.paddles.length),
  _ => '',
};

/// Not a live region: that would speak on every search, cutting off the
/// echo of the keys. The count is announced once results stop changing.
class _ResultCount extends ConsumerStatefulWidget {
  const _ResultCount();

  @override
  ConsumerState<_ResultCount> createState() => _ResultCountState();
}

class _ResultCountState extends ConsumerState<_ResultCount> {
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

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.semanticsLabel,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final String? semanticsLabel;
  final int badgeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: const StadiumBorder(),
        side: BorderSide(color: colors.outlineVariant),
        backgroundColor: colors.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: switch ((semanticsLabel, badgeCount)) {
                (final custom?, _) => custom,
                (null, 0) => label,
                (null, final count) => '$label, $count active',
              },
            ),
          ),
          if (badgeCount > 0) ...[
            const SizedBox(width: 6),
            ExcludeSemantics(
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onPrimary,
                    fontSize: 10,
                    letterSpacing: 0,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
