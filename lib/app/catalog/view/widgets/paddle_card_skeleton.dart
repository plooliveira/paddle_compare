import 'package:material_ui/material_ui.dart';

import 'paddle_card.dart';

class PaddleCardSkeleton extends StatelessWidget {
  const PaddleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final block = colors.surfaceContainerHighest;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: PaddleCard.imageAspectRatio,
            child: ColoredBox(color: block),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bar(width: 56, height: 8, color: block),
                const SizedBox(height: 12),
                _Bar(width: double.infinity, height: 12, color: block),
                const SizedBox(height: 8),
                _Bar(width: 72, height: 12, color: block),
                const SizedBox(height: 16),
                _Bar(width: 48, height: 12, color: block),
                const SizedBox(height: 18),
                _Bar(width: double.infinity, height: 44, color: block),
                const SizedBox(height: 8),
                _Bar(width: double.infinity, height: 44, color: block),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    ),
  );
}
