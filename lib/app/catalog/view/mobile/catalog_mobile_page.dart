import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../compare/controller/compare_controller.dart';
import '../../../compare/controller/compare_limits.dart';
import '../../controller/catalog_controller.dart';
import '../widgets/card_grid_layout.dart';
import '../widgets/catalog_header.dart';
import '../widgets/catalog_results.dart';
import '../widgets/catalog_search_field.dart';
import '../widgets/catalog_status.dart';
import '../widgets/compare_tray.dart';
import 'widgets/active_filters_bar.dart';
import 'widgets/catalog_toolbar.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/sort_sheet.dart';

class CatalogMobilePage extends ConsumerStatefulWidget {
  const CatalogMobilePage({super.key});

  @override
  ConsumerState<CatalogMobilePage> createState() => _CatalogMobilePageState();
}

class _CatalogMobilePageState extends ConsumerState<CatalogMobilePage> {
  static const _grid = CardGridLayout(
    columns: 2,
    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
    columnGap: 12,
    rowGap: 24,
  );

  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // New results start from the top. Under a deep-linked page the catalog
    // loads without ever being laid out; it is at the top already then.
    ref.listen(
      catalogControllerProvider.select((state) => state.value?.query),
      (_, _) {
        if (_scroll.hasClients && _scroll.position.hasContentDimensions) {
          _scroll.jumpTo(0);
        }
      },
    );
    final isRefreshing = ref.watch(
      catalogControllerProvider.select(
        (state) => CatalogStatus.from(state) == CatalogStatus.refreshing,
      ),
    );
    final isComparing = ref.watch(
      compareIdsProvider.select((ids) => ids.isNotEmpty),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        // Null rather than empty: a bar of any height, even zero, takes the
        // bottom padding away from the grid.
        bottomNavigationBar: isComparing
            ? const CompareTray(slots: CompareLimits.mobile)
            : null,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            controller: _scroll,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              const SliverToBoxAdapter(child: CatalogHeader()),
              PinnedHeaderSliver(child: _Controls(isRefreshing: isRefreshing)),
              const SliverToBoxAdapter(child: ActiveFiltersBar()),
              const CatalogResults(
                layout: _grid,
                compareLimit: CompareLimits.mobile,
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.isRefreshing});

  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CatalogSearchField(),
                const SizedBox(height: 6),
                CatalogToolbar(
                  onFilter: () => FilterSheet.show(context),
                  onSort: () => SortSheet.show(context),
                ),
              ],
            ),
          ),
          if (isRefreshing)
            // Same height as the divider, so nothing below moves.
            const LinearProgressIndicator(
              minHeight: 1,
              semanticsLabel: 'Updating results',
            )
          else
            const Divider(),
        ],
      ),
    );
  }
}
