import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/paddle/paddle_repository.dart';
import 'missing_spec.dart';

class PerformanceRatings extends StatelessWidget {
  const PerformanceRatings({super.key, required this.ratings});

  static const maxRating = 10;

  final PaddleRatings ratings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (label, rating) in [
          ('Power', ratings.power),
          ('Control', ratings.control),
          ('Spin', ratings.spin),
          ('Pop', ratings.pop),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: _RatingRow(label: label, rating: rating),
          ),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.label, required this.rating});

  final String label;
  final int? rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final rating = this.rating;

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: label,
      value: rating != null
          ? '$rating out of ${PerformanceRatings.maxRating}'
          : missingSpec,
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < PerformanceRatings.maxRating; i++) ...[
                  if (i > 0) const SizedBox(width: 3),
                  Expanded(
                    child: Container(
                      height: 6,
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
          SizedBox(
            width: 36,
            child: Text(
              rating?.toString() ?? missingSpecShort,
              textAlign: TextAlign.end,
              style: textTheme.titleSmall?.copyWith(
                color: rating != null ? null : colors.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
