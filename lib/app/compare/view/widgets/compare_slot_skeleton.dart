import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/skeleton_box.dart';
import 'compare_slot_image_box.dart';

class CompareSlotSkeleton extends StatelessWidget {
  const CompareSlotSkeleton({
    super.key,
    this.image,
    this.imageMaxHeight = double.infinity,
  });

  final Widget? image;
  final double imageMaxHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompareSlotImageBox(
          maxHeight: imageMaxHeight,
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
