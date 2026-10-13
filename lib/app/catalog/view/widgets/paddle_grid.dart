import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../router.dart';
import '../../controller/catalog_controller.dart';
import 'card_grid_layout.dart';
import 'card_grid_sliver.dart';
import 'load_more_footer.dart';
import 'paddle_card.dart';

class PaddleGrid extends ConsumerWidget {
  const PaddleGrid({
    super.key,
    required this.layout,
    required this.compareLimit,
  });

  final CardGridLayout layout;

  final int compareLimit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddles = ref.watch(
      catalogControllerProvider.select(
        (state) => state.value?.paddles ?? const <Paddle>[],
      ),
    );
    final compareIds = ref.watch(compareIdsProvider);
    final canCompare = compareIds.length < compareLimit;

    CatalogRoute route() => CatalogRoute.fromFilter(
      ref.read(catalogFilterProvider),
      compare: ref.read(compareIdsProvider),
    );

    return CardGridSliver(
      layout: layout,
      itemCount: paddles.length,
      itemBuilder: (context, index) {
        final paddle = paddles[index];
        final isCompared = compareIds.contains(paddle.id);
        return PaddleCard(
          paddle: paddle,
          onViewDetails: () => route().pushDetails(context, paddle.id),
          onCompare: canCompare && !isCompared
              ? () => route().addToCompare(
                  context,
                  paddle.id,
                  limit: compareLimit,
                )
              : null,
          isCompared: isCompared,
        );
      },
      footer: const LoadMoreFooter(),
    );
  }
}
