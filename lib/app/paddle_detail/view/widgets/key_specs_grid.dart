import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/missing_spec.dart';
import '../../../../core/utils/spec_format.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../shared/paddle_labels.dart';

class KeySpecsGrid extends StatelessWidget {
  const KeySpecsGrid({super.key, required this.paddle, this.columns = 2})
    : assert(columns == 2 || columns == 4);

  final Paddle paddle;

  final int columns;

  @override
  Widget build(BuildContext context) {
    final weight = paddle.weightOz;
    final core = paddle.coreThicknessMm;
    final face = paddle.faceMaterial;
    final tiles = [
      _SpecTile(label: 'Shape', value: paddle.shape?.label),
      _SpecTile(
        label: 'Weight',
        value: weight != null ? formatOunces(weight) : null,
        detail: weight != null ? formatOuncesAsGrams(weight) : null,
      ),
      _SpecTile(
        label: 'Core',
        value: core != null ? formatMillimeters(core) : null,
      ),
      _SpecTile(label: 'Face', value: face != null ? capitalize(face) : null),
    ];

    return Column(
      children: [
        for (var start = 0; start < tiles.length; start += columns) ...[
          if (start > 0) const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, tile)
                    in tiles.skip(start).take(columns).indexed) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(child: tile),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({required this.label, required this.value, this.detail});

  final String label;
  final String? value;

  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final valueStyle = textTheme.titleSmall!.copyWith(
      fontSize: 16,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final value = this.value;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                semanticsLabel: label,
                style: textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              if (value == null)
                Text(
                  missingSpecShort,
                  semanticsLabel: missingSpec,
                  style: valueStyle.copyWith(color: colors.onSurfaceVariant),
                )
              else
                Text.rich(
                  TextSpan(
                    text: value,
                    children: [
                      if (detail case final detail?)
                        TextSpan(
                          text: ' · $detail',
                          style: textTheme.bodySmall?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                    ],
                  ),
                  style: valueStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
