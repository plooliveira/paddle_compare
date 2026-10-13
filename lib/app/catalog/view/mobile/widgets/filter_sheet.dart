import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../../router.dart';
import '../../../../shared/paddle_labels.dart';
import '../../../controller/catalog_controller.dart';
import '../../../controller/catalog_filter.dart';
import '../../widgets/catalog_labels.dart';

/// Changes apply as they are made; the footer button only closes the sheet.
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  /// The sheet is a route outside the catalog's provider scope, so the scope
  /// of [context] is passed on to it.
  static Future<void> show(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => UncontrolledProviderScope(
        container: container,
        child: const FilterSheet(),
      ),
    );
  }

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  /// Slider values while dragging. Committed on release, so the catalog
  /// doesn't reload on every frame.
  RangeValues? _draggingPrice;

  void _apply(CatalogFilter Function(CatalogFilter filter) update) =>
      CatalogRoute.fromFilter(update(ref.read(catalogFilterProvider)))
          .goInPlace(context);

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(catalogFilterProvider);
    // Only a finished, complete result has a count worth showing.
    final count = ref.watch(
      catalogControllerProvider.select(
        (state) => switch (state) {
          AsyncData(isLoading: false, :final value) when !value.hasMore =>
            value.paddles.length,
          _ => null,
        },
      ),
    );
    final theme = Theme.of(context);

    final price =
        _draggingPrice ??
        RangeValues(
          filter.minPrice ?? CatalogFilter.priceBoundMin,
          filter.maxPrice ?? CatalogFilter.priceBoundMax,
        );

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Filters',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: filter.activeFilterCount == 0
                      ? null
                      : () => _apply((filter) => filter.reset()),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionLabel('SHAPE'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final shape in PaddleShape.values)
                        FilterChip(
                          label: Text(shape.label),
                          selected: filter.shapes.contains(shape),
                          onSelected: (_) =>
                              _apply((filter) => filter.toggleShape(shape)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _SectionLabel(
                    'PRICE',
                    trailing: priceRangeLabel(
                      _boundToNull(price.start, CatalogFilter.priceBoundMin),
                      _boundToNull(price.end, CatalogFilter.priceBoundMax),
                    ),
                  ),
                  RangeSlider(
                    values: price,
                    min: CatalogFilter.priceBoundMin,
                    max: CatalogFilter.priceBoundMax,
                    divisions:
                        (CatalogFilter.priceBoundMax -
                            CatalogFilter.priceBoundMin) ~/
                        _priceStep,
                    semanticFormatterCallback: (value) => '\$${value.round()}',
                    onChanged: (values) =>
                        setState(() => _draggingPrice = values),
                    onChangeEnd: (values) {
                      _apply(
                        (filter) => filter.copyWith(
                          minPrice: _boundToNull(
                            _snap(values.start),
                            CatalogFilter.priceBoundMin,
                          ),
                          maxPrice: _boundToNull(
                            _snap(values.end),
                            CatalogFilter.priceBoundMax,
                          ),
                        ),
                      );
                      setState(() => _draggingPrice = null);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${CatalogFilter.priceBoundMin.round()}',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          '\$${CatalogFilter.priceBoundMax.round()}+',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('In stock only'),
                    subtitle: Text(
                      'Hide paddles that are sold out',
                      style: theme.textTheme.bodySmall,
                    ),
                    value: filter.inStockOnly,
                    onChanged: (value) =>
                        _apply((filter) => filter.copyWith(inStockOnly: value)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                count == null
                    ? 'Show results'
                    : 'Show ${paddleCountLabel(count)}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _priceStep = 10.0;

/// Rounds to the slider's step. Its divisions leave float errors (e.g.
/// 219.99999999999997), which would show in the URL.
double _snap(double value) => (value / _priceStep).round() * _priceStep;

/// A value at the slider's bound means no limit on that end.
double? _boundToNull(double value, double bound) =>
    value == bound ? null : value;

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label, {this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(label, style: theme.textTheme.labelSmall),
            ),
          ),
          if (trailing case final trailing?)
            Text(
              trailing,
              style: theme.textTheme.labelLarge?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}
