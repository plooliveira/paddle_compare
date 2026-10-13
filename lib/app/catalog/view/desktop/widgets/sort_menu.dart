import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../../compare/controller/compare_controller.dart';
import '../../../../router.dart';
import '../../../controller/catalog_controller.dart';
import '../../widgets/catalog_labels.dart';

class SortMenu extends ConsumerWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(
      catalogFilterProvider.select((filter) => filter.sort),
    );
    final colors = Theme.of(context).colorScheme;

    return MenuAnchor(
      alignmentOffset: const Offset(0, 4),
      menuChildren: [
        for (final sort in PaddleSort.values)
          RadioMenuButton<PaddleSort>(
            value: sort,
            groupValue: current,
            onChanged: (sort) {
              if (sort == null) return;
              CatalogRoute.fromFilter(
                ref.read(catalogFilterProvider).copyWith(sort: sort),
                compare: ref.read(compareIdsProvider),
              ).goInPlace(context);
            },
            child: Text(sort.label),
          ),
      ],
      builder: (context, controller, _) => OutlinedButton.icon(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const StadiumBorder(),
          side: BorderSide(color: colors.outlineVariant),
          backgroundColor: colors.surface,
        ),
        icon: const Icon(Icons.swap_vert, size: 18),
        label: Text(
          'Sort: ${current.label}',
          semanticsLabel: 'Sort by ${current.label}',
        ),
      ),
    );
  }
}
