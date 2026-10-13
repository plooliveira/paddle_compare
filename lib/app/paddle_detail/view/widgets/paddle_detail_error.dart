import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/state_message.dart';
import '../../controller/paddle_detail_controller.dart';

class PaddleDetailError extends ConsumerWidget {
  const PaddleDetailError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: StateMessage(
            icon: Icons.cloud_off_outlined,
            title: 'Something went wrong',
            message: 'Check your connection and try again.',
            action: FilledButton(
              onPressed: ref
                  .read(paddleDetailControllerProvider.notifier)
                  .retry,
              child: const Text('Try again'),
            ),
          ),
        ),
      ],
    );
  }
}
