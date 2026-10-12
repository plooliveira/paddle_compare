import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import 'paddle_image.dart';

class PaddleCard extends StatelessWidget {
  const PaddleCard({
    super.key,
    required this.paddle,
    required this.onViewDetails,
  });

  static const imageAspectRatio = 4 / 5;
  static const nameMaxLines = 2;

  final Paddle paddle;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final price = paddle.priceUsd;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewDetails,
        // Screen readers get a single action: the button below.
        excludeFromSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: imageAspectRatio,
              child: ColoredBox(
                color: colors.surfaceContainerHighest,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: PaddleImage(imagePath: paddle.imagePath),
                      ),
                    ),
                    if (paddle.inStock == false)
                      const Positioned(top: 10, left: 10, child: _SoldOutTag()),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paddle.brand.toUpperCase(),
                    semanticsLabel: paddle.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(fontSize: 10.5),
                  ),
                  const SizedBox(height: 6),
                  _Name(paddle.name, style: textTheme.titleMedium!),
                  const SizedBox(height: 10),
                  Text(
                    price != null ? formatUsd(price) : 'Price unavailable',
                    style: price != null
                        ? textTheme.titleSmall?.copyWith(
                            fontSize: 15,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          )
                        : textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: OutlinedButton(
                onPressed: onViewDetails,
                child: Text(
                  'View details',
                  semanticsLabel: 'View details for ${paddle.name}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Always takes [PaddleCard.nameMaxLines] lines of height, so every card has
/// the same height and prices line up across the grid.
class _Name extends StatelessWidget {
  const _Name(this.name, {required this.style});

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final strut = StrutStyle.fromTextStyle(style, forceStrutHeight: true);
    final lineHeight = MediaQuery.textScalerOf(context)
        .scale(style.fontSize! * style.height!);
    return SizedBox(
      height: lineHeight * PaddleCard.nameMaxLines,
      child: Text(
        name,
        maxLines: PaddleCard.nameMaxLines,
        overflow: TextOverflow.ellipsis,
        style: style,
        strutStyle: strut,
      ),
    );
  }
}

class _SoldOutTag extends StatelessWidget {
  const _SoldOutTag();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Text(
          'SOLD OUT',
          semanticsLabel: 'Sold out',
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
