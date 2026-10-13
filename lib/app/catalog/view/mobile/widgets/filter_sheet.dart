import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../compare/controller/compare_controller.dart';
import '../../../../router.dart';
import '../../../controller/catalog_controller.dart';
import '../../widgets/catalog_filters.dart';
import '../../widgets/catalog_labels.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  /// The sheet is a route outside the catalog's provider scope, so the scope
  /// of [context] is passed on to it.
  static Future<void> show(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => UncontrolledProviderScope(
        container: container,
        child: const FilterSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(
      catalogFilterProvider.select((filter) => filter.activeFilterCount),
    );
    final count = ref.watch(
      catalogControllerProvider.select(
        (state) => switch (state) {
          AsyncData(isLoading: false, :final value) when !value.hasMore =>
            value.paddles.length,
          _ => null,
        },
      ),
    );
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Filters',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: activeFilters == 0
                      ? null
                      : () => CatalogRoute.fromFilter(
                          ref.read(catalogFilterProvider).reset(),
                          compare: ref.read(compareIdsProvider),
                        ).goInPlace(context),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          const Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: CatalogFilters(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                count == null
                    ? 'Show results'
                    : 'Show ${paddleCountLabel(count)}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
