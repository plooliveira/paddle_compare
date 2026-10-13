import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../router.dart';
import '../../../shared/paddle_labels.dart';
import '../../controller/catalog_controller.dart';
import '../../controller/catalog_filter.dart';
import 'catalog_labels.dart';

class CatalogFilters extends ConsumerStatefulWidget {
  const CatalogFilters({super.key});

  @override
  ConsumerState<CatalogFilters> createState() => _CatalogFiltersState();
}

class _CatalogFiltersState extends ConsumerState<CatalogFilters> {
  RangeValues? _draggingPrice;

  void _apply(CatalogFilter Function(CatalogFilter filter) update) =>
      CatalogRoute.fromFilter(
        update(ref.read(catalogFilterProvider)),
        compare: ref.read(compareIdsProvider),
      ).goInPlace(context);

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(catalogFilterProvider);
    final theme = Theme.of(context);

    final price =
        _draggingPrice ??
        RangeValues(
          filter.minPrice ?? CatalogFilter.priceBoundMin,
          filter.maxPrice ?? CatalogFilter.priceBoundMax,
        );

    return Column(
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
              (CatalogFilter.priceBoundMax - CatalogFilter.priceBoundMin) ~/
              _priceStep,
          semanticFormatterCallback: (value) => '\$${value.round()}',
          onChanged: (values) => setState(() => _draggingPrice = values),
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
    );
  }
}

const _priceStep = 10.0;

double _snap(double value) => (value / _priceStep).round() * _priceStep;

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
