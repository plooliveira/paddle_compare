import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../core/widgets/paddle_image.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import 'compare_slot_image_box.dart';

class CompareSlotHeader extends StatelessWidget {
  const CompareSlotHeader({
    super.key,
    required this.paddle,
    this.imageMaxHeight = double.infinity,
  });

  static const nameMaxLines = 2;

  final Paddle paddle;
  final double imageMaxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final price = paddle.priceUsd;

    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CompareSlotImageBox(
            maxHeight: imageMaxHeight,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PaddleImage(imagePath: paddle.imagePath),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            paddle.brand.toUpperCase(),
            semanticsLabel: paddle.brand,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall,
          ),
          const SizedBox(height: 6),
          _Name(paddle.name, style: textTheme.titleMedium!),
          const SizedBox(height: 8),
          Text(
            price != null ? formatUsd(price) : 'Price unavailable',
            style: price != null
                ? textTheme.titleSmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  )
                : textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Always takes [CompareSlotHeader.nameMaxLines] lines of height, so prices
/// line up across the columns.
class _Name extends StatelessWidget {
  const _Name(this.name, {required this.style});

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final strut = StrutStyle.fromTextStyle(style, forceStrutHeight: true);
    final lineHeight = MediaQuery.textScalerOf(context)
        .scale(style.fontSize! * style.height!);
    return Semantics(
      header: true,
      child: SizedBox(
        height: lineHeight * CompareSlotHeader.nameMaxLines,
        child: Text(
          name,
          maxLines: CompareSlotHeader.nameMaxLines,
          overflow: TextOverflow.ellipsis,
          style: style,
          strutStyle: strut,
        ),
      ),
    );
  }
}
