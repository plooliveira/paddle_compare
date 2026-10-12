import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../controller/catalog_controller.dart';
import '../../widgets/paddle_card.dart';
import 'load_more_footer.dart';
import 'two_column_sliver.dart';

class PaddleGrid extends ConsumerWidget {
  const PaddleGrid({super.key, required this.onViewDetails});

  final ValueChanged<Paddle> onViewDetails;

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
        return PaddleCard(
          paddle: paddle,
          onViewDetails: () => onViewDetails(paddle),
        );
      },
      footer: const LoadMoreFooter(),
    );
  }
}
