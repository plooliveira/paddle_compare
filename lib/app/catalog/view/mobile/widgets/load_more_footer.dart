import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../controller/catalog_controller.dart';

/// Last item of the grid. Being built means it scrolled near the viewport,
/// so it asks for the next page.
class LoadMoreFooter extends ConsumerWidget {
  const LoadMoreFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      catalogControllerProvider.select(
        (state) => switch (state.value) {
          final value? => (
            hasMore: value.hasMore,
            isLoading: value.isLoadingMore,
            failed: value.loadMoreError != null,
            isEmpty: value.paddles.isEmpty,
          ),
          null => null,
        },
      ),
    );
    final theme = Theme.of(context);

    if (status == null || (status.isEmpty && !status.hasMore)) {
      return const SizedBox.shrink();
    }

    // No auto-retry, so a failing API doesn't loop.
    if (status.failed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              "Couldn't load more paddles.",
              style: theme.textTheme.bodySmall,
            ),
            TextButton(
              onPressed: ref.read(catalogControllerProvider.notifier).loadMore,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (status.hasMore) {
      if (!status.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(catalogControllerProvider.notifier).loadMore();
          }
        });
      }
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              semanticsLabel: 'Loading more paddles',
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'END OF THE COLLECTION',
              semanticsLabel: 'End of the collection',
              style: theme.textTheme.labelSmall,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
