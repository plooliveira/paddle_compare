import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../controller/catalog_controller.dart';
import '../../widgets/paddle_card.dart';
import 'load_more_footer.dart';
import 'two_column_sliver.dart';

class PaddleGrid extends ConsumerWidget {
  const PaddleGrid({
    super.key,
    required this.onViewDetails,
    this.onCompare,
    this.compareIds = const [],
  });

  final ValueChanged<Paddle> onViewDetails;

  /// Adds a paddle to the comparison. Null when the comparison is full, which
  /// disables every card's "Compare" button.
  final ValueChanged<Paddle>? onCompare;

  /// Cards of these paddles show them as added, with "Compare" disabled.
  final List<String> compareIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddles = ref.watch(
      catalogControllerProvider.select(
        (state) => state.value?.paddles ?? const <Paddle>[],
      ),
    );
    return TwoColumnSliver(
      itemCount: paddles.length,
      itemBuilder: (context, index) {
        final paddle = paddles[index];
        final onCompare = this.onCompare;
        final isCompared = compareIds.contains(paddle.id);
        return PaddleCard(
          paddle: paddle,
          onViewDetails: () => onViewDetails(paddle),
          onCompare: onCompare != null && !isCompared
              ? () => onCompare(paddle)
              : null,
          isCompared: isCompared,
        );
      },
      footer: const LoadMoreFooter(),
    );
  }
}
