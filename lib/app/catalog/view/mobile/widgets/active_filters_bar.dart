import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../compare/controller/compare_controller.dart';
import '../../../../router.dart';
import '../../../../shared/paddle_labels.dart';
import '../../../controller/catalog_controller.dart';
import '../../../controller/catalog_filter.dart';
import '../../widgets/catalog_labels.dart';

class ActiveFiltersBar extends ConsumerWidget {
  const ActiveFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(catalogFilterProvider);
    if (filter.activeFilterCount == 0) return const SizedBox.shrink();

    void apply(CatalogFilter filter) => CatalogRoute.fromFilter(
      filter,
      compare: ref.read(compareIdsProvider),
    ).goInPlace(context);

    Widget chip(String label, VoidCallback onDeleted) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InputChip(
        label: Text(label),
        labelStyle: Theme.of(context).textTheme.labelMedium,
        visualDensity: VisualDensity.compact,
        onDeleted: onDeleted,
        deleteIcon: const Icon(Icons.close, size: 16),
        deleteButtonTooltipMessage: 'Remove $label filter',
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
      child: Row(
        children: [
          for (final shape in filter.shapes)
            chip(shape.label, () => apply(filter.toggleShape(shape))),
          if (filter.minPrice != null || filter.maxPrice != null)
            chip(
              filter.priceLabel,
              () => apply(filter.copyWith(minPrice: null, maxPrice: null)),
            ),
          if (filter.inStockOnly)
            chip('In stock', () => apply(filter.copyWith(inStockOnly: false))),
          TextButton(
            onPressed: () => apply(filter.reset()),
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(decoration: TextDecoration.underline),
            ),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}
