import 'package:material_ui/material_ui.dart';

import '../../../../../core/widgets/skeleton_box.dart';
import '../../../../../core/widgets/skeleton_pulse.dart';
import 'compare_action.dart';

/// The content column while the paddle loads, with the compare button in
/// place but disabled. The page puts the image's placeholder beside it.
class PaddleDetailDesktopSkeleton extends StatelessWidget {
  const PaddleDetailDesktopSkeleton({super.key, required this.keySpecColumns});

  final int keySpecColumns;

  @override
  Widget build(BuildContext context) {
    Widget pulse(List<Widget> children) => ExcludeSemantics(
      child: SkeletonPulse(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: 'Loading paddle',
          child: pulse(const [
            SkeletonBox(width: 64, height: 8),
            SizedBox(height: 14),
            SkeletonBox(width: 360, height: 30),
            SizedBox(height: 18),
            SkeletonBox(width: 96, height: 20),
            SizedBox(height: 20),
            SkeletonBox(height: 12),
            SizedBox(height: 8),
            SkeletonBox(width: 260, height: 12),
          ]),
        ),
        const SizedBox(height: 24),
        const CompareAction(paddleId: null),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 32),
        pulse([
          const SkeletonBox(width: 72, height: 8),
          const SizedBox(height: 14),
          for (var start = 0; start < 4; start += keySpecColumns) ...[
            if (start > 0) const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < keySpecColumns; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  const Expanded(child: SkeletonBox(height: 64)),
                ],
              ],
            ),
          ],
          const SizedBox(height: 36),
          const SkeletonBox(width: 88, height: 8),
          for (var i = 0; i < 4; i++) ...[
            const SizedBox(height: 14),
            const SkeletonBox(height: 6),
          ],
        ]),
      ],
    );
  }
}
