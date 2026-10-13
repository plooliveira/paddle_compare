import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../compare/controller/compare_controller.dart';
import '../../../../router.dart';
import '../../../controller/catalog_controller.dart';
import '../../widgets/catalog_filters.dart';

class FilterSidebar extends ConsumerWidget {
  const FilterSidebar({super.key, required this.headerHeight});

  final double headerHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(
      catalogFilterProvider.select((filter) => filter.activeFilterCount),
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: headerHeight,
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text('Filters', style: theme.textTheme.titleMedium),
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
        const Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 24),
            child: CatalogFilters(),
          ),
        ),
      ],
    );
  }
}
