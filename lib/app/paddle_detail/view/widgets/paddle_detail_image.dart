import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/paddle_image.dart';

class PaddleDetailImage extends StatelessWidget {
  const PaddleDetailImage({super.key, required this.imagePath});

  static const maxHeight = 360.0;

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
        aspectRatio: 1,
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
