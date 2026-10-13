import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/missing_spec.dart';
import '../../../../core/utils/spec_format.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';

/// Every spec that isn't a key spec, one per row. A missing one says so
/// instead of being left out.
class FullSpecsList extends StatelessWidget {
  const FullSpecsList({super.key, required this.paddle});

  final Paddle paddle;

  @override
  Widget build(BuildContext context) {
    final dimensions = paddle.dimensions;
    String? inches(double? value) => value != null ? formatInches(value) : null;
    String? decimal(double? value) =>
        value != null ? formatDecimal(value) : null;
    final specs = [
      ('Length', inches(dimensions.lengthIn)),
      ('Width', inches(dimensions.widthIn)),
      ('Handle length', inches(dimensions.handleLengthIn)),
      ('Grip circumference', inches(paddle.gripCircumferenceIn)),
      ('Swing weight', decimal(paddle.swingWeight)),
      ('Twist weight', decimal(paddle.twistWeight)),
      ('Release year', paddle.releaseYear?.toString()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, (label, value)) in specs.indexed) ...[
          if (index > 0) const Divider(),
          _SpecRow(label: label, value: value),
        ],
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = theme.colorScheme.onSurfaceVariant;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(color: muted),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              value ?? missingSpec,
              style: value != null
                  ? textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    )
                  : textTheme.bodyMedium?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
