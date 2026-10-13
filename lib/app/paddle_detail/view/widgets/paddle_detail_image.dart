import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/paddle_image.dart';

class PaddleDetailImage extends StatelessWidget {
  const PaddleDetailImage({
    super.key,
    required this.imagePath,
    this.aspectRatio = 1,
    this.maxHeight = defaultMaxHeight,
  });

  static const defaultMaxHeight = 360.0;

  final String? imagePath;
  final double aspectRatio;

  /// [double.infinity] leaves the height to the parent's constraints.
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            border: Border.all(color: colors.outlineVariant),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: PaddleImage(imagePath: imagePath),
          ),
        ),
      ),
    );
  }
}
