import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';

class PaddleDetailHeader extends StatelessWidget {
  const PaddleDetailHeader({super.key, required this.paddle});

  final Paddle paddle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = theme.colorScheme.onSurfaceVariant;
    final price = paddle.priceUsd;
    final inStock = paddle.inStock;
    final description = paddle.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paddle.brand.toUpperCase(),
          semanticsLabel: paddle.brand,
          style: textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: Text(paddle.name, style: textTheme.headlineMedium),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Text(
                price != null ? formatUsd(price) : 'Price unavailable',
                style: price != null
                    ? textTheme.titleSmall?.copyWith(
                        fontSize: 20,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      )
                    : textTheme.bodyMedium?.copyWith(color: muted),
              ),
            ),
            if (inStock != null) _Availability(inStock: inStock),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 16),
          Text(description, style: textTheme.bodyLarge?.copyWith(color: muted)),
        ],
      ],
    );
  }
}

class _Availability extends StatelessWidget {
  const _Availability({required this.inStock});

  final bool inStock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = inStock
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: inStock ? color : null,
            border: inStock ? null : Border.all(color: color, width: 1.2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          inStock ? 'In stock' : 'Sold out',
          style: theme.textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
