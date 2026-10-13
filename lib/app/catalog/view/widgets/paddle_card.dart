import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../core/widgets/paddle_image.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';

class PaddleCard extends StatelessWidget {
  const PaddleCard({
    super.key,
    required this.paddle,
    required this.onViewDetails,
    this.onCompare,
    this.isCompared = false,
  });

  static const imageAspectRatio = 4 / 5;
  static const nameMaxLines = 2;

  final Paddle paddle;
  final VoidCallback onViewDetails;

  /// Adds this paddle to the comparison. When null, the "Compare" button is
  /// disabled.
  final VoidCallback? onCompare;

  /// Whether this paddle is already in the comparison. Its button then says
  /// so instead of offering "Compare".
  final bool isCompared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final price = paddle.priceUsd;

    final onCompare = this.onCompare;

    // Screen readers stop once per card: brand, name, price and "View
    // details". Adding to the comparison is a custom action.
    return MergeSemantics(
      child: Semantics(
        customSemanticsActions: onCompare != null
            ? {_addToCompareAction: onCompare}
            : null,
        value: isCompared ? 'Added to compare' : null,
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colors.outlineVariant),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Only the image and the text open the details: a tap on a
              // disabled button, or around the buttons, does nothing.
              Expanded(
                child: InkWell(
                  onTap: onViewDetails,
                  // Screen readers get the "View details" button instead.
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
                                  child: PaddleImage(
                                    imagePath: paddle.imagePath,
                                  ),
                                ),
                              ),
                              if (paddle.inStock == false)
                                const Positioned(
                                  top: 10,
                                  left: 10,
                                  child: _SoldOutTag(),
                                ),
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
                              style: textTheme.labelSmall,
                            ),
                            const SizedBox(height: 6),
                            _Name(paddle.name, style: textTheme.titleMedium!),
                            const SizedBox(height: 10),
                            Text(
                              price != null
                                  ? formatUsd(price)
                                  : 'Price unavailable',
                              style: price != null
                                  ? textTheme.titleSmall?.copyWith(
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    )
                                  : textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: onViewDetails,
                      child: const Text('View details'),
                    ),
                    const SizedBox(height: 8),
                    // Reaches screen readers as the custom action above.
                    ExcludeSemantics(
                      child: OutlinedButton.icon(
                        onPressed: onCompare,
                        icon: Icon(
                          isCompared ? Icons.check : Icons.compare_arrows,
                          size: 18,
                        ),
                        label: Text(isCompared ? 'Added' : 'Compare'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _addToCompareAction = CustomSemanticsAction(label: 'Add to compare');

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
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
