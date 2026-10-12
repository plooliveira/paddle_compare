import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../../../core/widgets/adaptive_view.dart';
import '../controller/catalog_controller.dart';
import '../controller/catalog_filter.dart';
import 'mobile/catalog_mobile_page.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key, required this.filter});

  /// From the URL. A new one reloads the catalog.
  final CatalogFilter filter;

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  /// Overrides [catalogFilterProvider] for this subtree, which scopes the
  /// catalog's controller to it too.
  late final _container = ProviderContainer(
    parent: ProviderScope.containerOf(context, listen: false),
    overrides: _overrides,
  );

  List<Override> get _overrides => [
    catalogFilterProvider.overrideWithValue(widget.filter),
  ];

  @override
  void didUpdateWidget(CatalogView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter == oldWidget.filter) return;
    // Applied after this frame rather than during the build, as ProviderScope
    // would: an open sheet shares the container from outside this subtree,
    // and must not be marked dirty while the tree is building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _container.updateOverrides(_overrides);
    });
  }

  @override
  void dispose() {
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: _container,
      child: AdaptiveView(
        mobile: (_) => const CatalogMobilePage(),
        // TODO: desktop variant. The mobile one stands in until then.
        desktop: (_) => const CatalogMobilePage(),
      ),
    );
  }
}
