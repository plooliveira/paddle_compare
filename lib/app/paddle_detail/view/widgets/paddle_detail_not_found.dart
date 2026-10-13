import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/state_message.dart';
import '../../../router.dart';

/// Fills the page's body, centered, and scrolls if the window is too short.
class PaddleDetailNotFound extends StatelessWidget {
  const PaddleDetailNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: StateMessage(
            icon: Icons.search_off,
            title: 'Paddle not found',
            message:
                'It may have been removed, or the link may be wrong. '
                'Browse the collection to find another one.',
            action: OutlinedButton(
              onPressed: () => const CatalogRoute().go(context),
              child: const Text('Browse paddles'),
            ),
          ),
        ),
      ],
    );
  }
}
