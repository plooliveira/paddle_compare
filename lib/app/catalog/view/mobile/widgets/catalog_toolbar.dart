import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../controller/catalog_controller.dart';
import '../../widgets/catalog_labels.dart';
import '../../widgets/catalog_result_count.dart';

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
        const CatalogResultCount(),
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
