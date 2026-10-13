import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../compare/controller/compare_controller.dart';
import '../../../compare/controller/compare_limits.dart';
import '../../controller/catalog_controller.dart';
import '../widgets/card_grid_layout.dart';
import '../widgets/catalog_header.dart';
import '../widgets/catalog_result_count.dart';
import '../widgets/catalog_results.dart';
import '../widgets/catalog_search_field.dart';
import '../widgets/catalog_status.dart';
import '../../../compare/view/widgets/compare_tray.dart';
import 'widgets/filter_sidebar.dart';
import 'widgets/sort_menu.dart';

class CatalogDesktopPage extends ConsumerStatefulWidget {
  const CatalogDesktopPage({super.key});

  @override
  ConsumerState<CatalogDesktopPage> createState() => _CatalogDesktopPageState();
}

class _CatalogDesktopPageState extends ConsumerState<CatalogDesktopPage> {
  static const _gutter = 24.0;
  static const _maxContentWidth = 1200.0;
  static const _compactWidth = 1024.0;

  static const _listHeaderHeight = 48.0;

  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < _compactWidth;
    final margin = math.max(_gutter, (width - _maxContentWidth) / 2);

    return Scaffold(
      bottomNavigationBar: isComparing
          ? CompareTray(
              slots: CompareLimits.desktop,
              padding: EdgeInsets.fromLTRB(margin, 12, margin, 12),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(margin: margin, isRefreshing: isRefreshing),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: margin),
                    child: SizedBox(
                      width: isCompact ? 216 : 240,
                      child: const FilterSidebar(
                        headerHeight: _listHeaderHeight,
                      ),
                    ),
                  ),
                  VerticalDivider(width: isCompact ? 32 : 48),
                  Expanded(
                    child: CustomScrollView(
                      controller: _scroll,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(right: margin),
                          sliver: const SliverToBoxAdapter(
                            child: SizedBox(
                              height: _listHeaderHeight,
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: CatalogResultCount(),
                              ),
                            ),
                          ),
                        ),
                        CatalogResults(
                          layout: CardGridLayout(
                            columns: 3,
                            padding: EdgeInsets.fromLTRB(0, 16, margin, 0),
                            columnGap: isCompact ? 16 : 20,
                            rowGap: 32,
                          ),
                          compareLimit: CompareLimits.desktop,
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.margin, required this.isRefreshing});

  static const _searchMinWidth = 220.0;
  static const _searchMaxWidth = 420.0;

  static const _searchReserve = 560.0;

  final double margin;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final contentWidth = MediaQuery.sizeOf(context).width - 2 * margin;
    final searchWidth = (contentWidth - _searchReserve).clamp(
      _searchMinWidth,
      _searchMaxWidth,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(margin, 24, margin, 20),
          child: Row(
            children: [
              const Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CatalogHeader(padding: EdgeInsets.zero),
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(width: searchWidth, child: const CatalogSearchField()),
              const SizedBox(width: 12),
              const SortMenu(),
            ],
          ),
        ),
        if (isRefreshing)
          const LinearProgressIndicator(
            minHeight: 1,
            semanticsLabel: 'Updating results',
          )
        else
          const Divider(),
      ],
    );
  }
}
