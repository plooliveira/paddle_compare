import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/utils/missing_spec.dart';
import '../../../../../core/widgets/skeleton_box.dart';
import '../../../../../data/repositories/paddle/paddle_repository.dart';
import '../../widgets/compare_specs.dart';

/// A spec across the comparison: its label, then one cell per column. Built
/// row by row, so values line up even when one of them wraps.
class CompareSpecRow extends StatelessWidget {
  CompareSpecRow.text({
    super.key,
    required CompareSpec spec,
    required this.slots,
  }) : label = spec.label,
       _cell = ((paddle) =>
           _TextCell(paddle: paddle, value: spec.value(paddle)));

  CompareSpecRow.rating({
    super.key,
    required CompareRating spec,
    required this.slots,
  }) : label = spec.label,
       _cell = ((paddle) =>
           _RatingCell(paddle: paddle, rating: spec.rating(paddle)));

  static const columnGap = 12.0;

  final String label;

  /// One per column: null when it has no paddle yet.
  final List<AsyncValue<Paddle?>?> slots;

  final Widget Function(Paddle) _cell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            semanticsLabel: label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (index, slot) in slots.indexed) ...[
                if (index > 0) const SizedBox(width: columnGap),
                Expanded(
                  child: switch (slot) {
                    null || AsyncValue(isLoading: true) => const _Placeholder(),
                    AsyncValue(hasError: true) => const SizedBox.shrink(),
                    AsyncValue(value: final paddle?) => _cell(paddle),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// The height of a line of values, so a row keeps its height once loaded.
const _lineHeight = 20.0;

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: SizedBox(
      height: _lineHeight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SkeletonBox(width: 64, height: 12),
      ),
    ),
  );
}

class _TextCell extends StatelessWidget {
  const _TextCell({required this.paddle, required this.value});

  final Paddle paddle;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final value = this.value;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: paddle.name,
      value: value ?? missingSpec,
      child: Text(
        value ?? missingSpecShort,
        style: value != null
            ? textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              )
            : textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }
}

class _RatingCell extends StatelessWidget {
  const _RatingCell({required this.paddle, required this.rating});

  final Paddle paddle;
  final int? rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final rating = this.rating;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: paddle.name,
      value: rating != null
          ? '$rating out of ${CompareSpecs.maxRating}'
          : missingSpec,
      child: SizedBox(
        height: _lineHeight,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                rating?.toString() ?? missingSpecShort,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: rating != null ? null : colors.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  for (var i = 0; i < CompareSpecs.maxRating; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i < (rating ?? 0)
                              ? colors.onSurface
                              : colors.outlineVariant,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
