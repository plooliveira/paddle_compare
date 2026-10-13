import 'package:material_ui/material_ui.dart';

/// A placeholder block with the size of the content it stands in for.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height});

  /// Null fills the available space.
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    ),
  );
}
