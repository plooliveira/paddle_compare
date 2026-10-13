import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../../compare/controller/compare_controller.dart';
import '../../../../router.dart';
import '../../../controller/catalog_controller.dart';
import '../../widgets/catalog_labels.dart';

class SortSheet extends ConsumerWidget {
  const SortSheet({super.key});

  /// The sheet is a route outside the catalog's provider scope, so the scope
  /// of [context] is passed on to it.
  static Future<void> show(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (_) => UncontrolledProviderScope(
        container: container,
        child: const SortSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(
      catalogFilterProvider.select((filter) => filter.sort),
    );
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Semantics(
                header: true,
                child: Text('Sort by', style: theme.textTheme.headlineSmall),
              ),
            ),
            for (final sort in PaddleSort.values)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: Text(sort.label),
                selected: sort == current,
                selectedColor: theme.colorScheme.onSurface,
                titleTextStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: sort == current ? FontWeight.w600 : null,
                ),
                trailing: sort == current
                    ? const Icon(Icons.check, size: 20)
                    : null,
                onTap: () {
                  CatalogRoute.fromFilter(
                    ref.read(catalogFilterProvider).copyWith(sort: sort),
                    compare: ref.read(compareIdsProvider),
                  ).goInPlace(context);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
