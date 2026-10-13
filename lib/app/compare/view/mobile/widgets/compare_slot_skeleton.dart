import 'package:material_ui/material_ui.dart';

import '../../../../../core/widgets/skeleton_box.dart';
import 'compare_slot_header.dart';

/// Placeholder with the shape of a [CompareSlotHeader]. Still: the parent
/// adds the pulse when it stands in for a paddle that is loading.
class CompareSlotSkeleton extends StatelessWidget {
  const CompareSlotSkeleton({super.key, this.image});

  /// Takes the place of the illustration's block.
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: CompareSlotHeader.imageAspectRatio,
          child: image ?? const SkeletonBox(),
        ),
        const SizedBox(height: 14),
        const SkeletonBox(width: 56, height: 8),
        const SizedBox(height: 12),
        const SkeletonBox(height: 14),
        const SizedBox(height: 8),
        const SkeletonBox(width: 88, height: 14),
        const SizedBox(height: 14),
        const SkeletonBox(width: 64, height: 14),
      ],
    );
  }
}
