import 'package:material_ui/material_ui.dart';

/// Paddle illustration, or a quiet placeholder when the path is missing or
/// the asset fails to load.
class PaddleImage extends StatelessWidget {
  const PaddleImage({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path == null) return const _MissingImage();

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) => Image.asset(
        path,
        fit: BoxFit.contain,
        // The card describes the paddle; the illustration adds nothing.
        excludeFromSemantics: true,
        cacheWidth: constraints.maxWidth.isFinite
            ? (constraints.maxWidth * pixelRatio).round()
            : null,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) => const _MissingImage(),
      ),
    );
  }
}

class _MissingImage extends StatelessWidget {
  const _MissingImage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports_tennis_outlined, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            'NO IMAGE',
            semanticsLabel: 'No image',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
