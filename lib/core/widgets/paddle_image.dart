import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class PaddleImage extends StatefulWidget {
  const PaddleImage({super.key, required this.imagePath});
  static const decodeWidthStep = 256;

  final String? imagePath;

  @override
  State<PaddleImage> createState() => _PaddleImageState();
}

class _PaddleImageState extends State<PaddleImage> {
  int? _decodeWidth;
  bool _shown = false;

  @override
  void didUpdateWidget(PaddleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imagePath != oldWidget.imagePath) {
      _decodeWidth = null;
      _shown = false;
    }
  }

  int? _decodeWidthFor(BoxConstraints constraints) {
    // On web the browser decodes at full size anyway, and resizing adds a
    // synchronous GPU pass per image on the main thread.
    if (kIsWeb) return null;
    if (!constraints.maxWidth.isFinite) return _decodeWidth;
    final pixels =
        constraints.maxWidth * MediaQuery.devicePixelRatioOf(context);
    const step = PaddleImage.decodeWidthStep;
    final needed = (pixels / step).ceil() * step;
    if (_decodeWidth case final current? when current >= needed) {
      return current;
    }
    return _decodeWidth = needed;
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.imagePath;
    if (path == null) return const _MissingImage();

    return LayoutBuilder(
      builder: (context, constraints) => Image.asset(
        path,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
        cacheWidth: _decodeWidthFor(constraints),
        gaplessPlayback: true,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame != null) _shown = true;
          if (wasSynchronouslyLoaded || _shown) return child;
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

  static const _captionMinHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: constraints.maxHeight < _captionMinHeight
            ? Icon(
                Icons.sports_tennis_outlined,
                size: 20,
                color: color,
                semanticLabel: 'No image',
              )
            : Column(
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
      ),
    );
  }
}
