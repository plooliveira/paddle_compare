import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/state_message.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../router.dart';
import '../../controller/catalog_controller.dart';
import 'card_grid_layout.dart';
import 'catalog_loading_sliver.dart';
import 'catalog_status.dart';
import 'paddle_grid.dart';

class CatalogResults extends ConsumerWidget {
  const CatalogResults({
    super.key,
    required this.layout,
    required this.compareLimit,
  });

  final CardGridLayout layout;
  final int compareLimit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      catalogControllerProvider.select(CatalogStatus.from),
    );
    final isRefreshing = status == CatalogStatus.refreshing;

    return switch (status) {
      CatalogStatus.loading => CatalogLoadingSliver(layout: layout),
      CatalogStatus.error => SliverFillRemaining(
        hasScrollBody: false,
        child: StateMessage(
          icon: Icons.cloud_off_outlined,
          title: 'Something went wrong',
          message: 'Check your connection and try again.',
          action: FilledButton(
            onPressed: ref.read(catalogControllerProvider.notifier).retry,
            child: const Text('Try again'),
          ),
        ),
      ),
      // Wrapped while ready too, so the grid isn't rebuilt from scratch when
      // a reload starts or ends.
      CatalogStatus.ready || CatalogStatus.refreshing => SliverOpacity(
        opacity: isRefreshing ? 0.4 : 1,
        sliver: SliverIgnorePointer(
          ignoring: isRefreshing,
          sliver: _Loaded(layout: layout, compareLimit: compareLimit),
        ),
      ),
    };
  }
}

class _Loaded extends ConsumerWidget {
  const _Loaded({required this.layout, required this.compareLimit});

  final CardGridLayout layout;
  final int compareLimit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(
      catalogControllerProvider.select(
        (state) => state.value?.paddles.isEmpty ?? false,
      ),
    );
    if (!isEmpty) {
      return PaddleGrid(layout: layout, compareLimit: compareLimit);
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: StateMessage(
        icon: Icons.search_off,
        title: 'No paddles found',
        message: 'Try a different search or adjust your filters.',
        action: OutlinedButton(
          onPressed: () => CatalogRoute.fromFilter(
            ref.read(catalogFilterProvider).cleared(),
            compare: ref.read(compareIdsProvider),
          ).goInPlace(context),
          child: const Text('Clear filters'),
        ),
      ),
    );
  }
}
