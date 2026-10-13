import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/state_message.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../compare/controller/compare_limits.dart';
import '../../../router.dart';
import '../../controller/catalog_controller.dart';
import 'widgets/active_filters_bar.dart';
import 'widgets/catalog_header.dart';
import 'widgets/catalog_loading_sliver.dart';
import 'widgets/catalog_search_field.dart';
import 'widgets/catalog_toolbar.dart';
import 'widgets/compare_tray.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/paddle_grid.dart';
import 'widgets/sort_sheet.dart';

class CatalogMobilePage extends ConsumerStatefulWidget {
  const CatalogMobilePage({super.key});

  @override
  ConsumerState<CatalogMobilePage> createState() => _CatalogMobilePageState();
}

enum _Status { loading, refreshing, error, ready }

class _CatalogMobilePageState extends ConsumerState<CatalogMobilePage> {
  static const _searchDebounce = Duration(milliseconds: 300);

  late final _search = TextEditingController(
    text: ref.read(catalogFilterProvider).query,
  );
  final _scroll = ScrollController();
  Timer? _searchTimer;

  String? _sentQuery;

  @override
  void dispose() {
    _searchTimer?.cancel();
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onQueryChanged(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(_searchDebounce, () {
      // Read when it fires: other filters may have changed while typing.
      final filter = ref.read(catalogFilterProvider);
      if (text == filter.query) return;
      _sentQuery = text;
      CatalogRoute.fromFilter(
        filter.copyWith(query: text),
        compare: ref.read(compareIdsProvider),
      ).goInPlace(context);
    });
  }

  CatalogRoute get _route => CatalogRoute.fromFilter(
    ref.read(catalogFilterProvider),
    compare: ref.read(compareIdsProvider),
  );

  void _openDetails(Paddle paddle) => _route.pushDetails(context, paddle.id);

  void _addToCompare(Paddle paddle) {
    final next = _route.withCompare([
      ...ref.read(compareIdsProvider),
      paddle.id,
    ]);
    if (next.compareIds.length >= CompareLimits.mobile) {
      next.goCompare(context);
    } else {
      next.goInPlace(context);
    }
  }

  void _openComparison() => _route.goCompare(context);

  void _removeFromComparison(String id) => _route
      .withCompare([
        for (final other in ref.read(compareIdsProvider))
          if (other != id) other,
      ])
      .goInPlace(context);

  @override
  Widget build(BuildContext context) {
    // Keeps the field in sync when the search changes elsewhere (e.g. "Clear
    // filters"), and drops a pending search that would undo that change.
    ref.listen(catalogFilterProvider.select((filter) => filter.query), (
      _,
      query,
    ) {
      if (query == _search.text || query == _sentQuery) return;
      _searchTimer?.cancel();
      _search.text = query;
    });
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
    final status = ref.watch(
      catalogControllerProvider.select(
        (state) => switch (state) {
          AsyncValue(isLoading: true, hasValue: true, hasError: false) =>
            _Status.refreshing,
          AsyncValue(isLoading: true) => _Status.loading,
          // Even with results from before: they don't match the chips.
          AsyncValue(hasError: true) => _Status.error,
          _ => _Status.ready,
        },
      ),
    );
    final isRefreshing = status == _Status.refreshing;
    final compareIds = ref.watch(compareIdsProvider);
    final canCompare = compareIds.length < CompareLimits.mobile;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        // Null rather than empty: a bar of any height, even zero, takes the
        // bottom padding away from the grid.
        bottomNavigationBar: compareIds.isEmpty
            ? null
            : CompareTray(
                onOpen: _openComparison,
                onRemove: _removeFromComparison,
              ),
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            controller: _scroll,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              const SliverToBoxAdapter(child: CatalogHeader()),
              PinnedHeaderSliver(
                child: _Controls(
                  search: _search,
                  isRefreshing: isRefreshing,
                  onQueryChanged: _onQueryChanged,
                ),
              ),
              const SliverToBoxAdapter(child: ActiveFiltersBar()),
              switch (status) {
                _Status.loading => const CatalogLoadingSliver(),
                _Status.error => SliverFillRemaining(
                  hasScrollBody: false,
                  child: StateMessage(
                    icon: Icons.cloud_off_outlined,
                    title: 'Something went wrong',
                    message: 'Check your connection and try again.',
                    action: FilledButton(
                      onPressed: ref
                          .read(catalogControllerProvider.notifier)
                          .retry,
                      child: const Text('Try again'),
                    ),
                  ),
                ),
                // Wrapped while ready too, so the grid isn't rebuilt from
                // scratch when a reload starts or ends.
                _Status.ready || _Status.refreshing => SliverOpacity(
                  opacity: isRefreshing ? 0.4 : 1,
                  sliver: SliverIgnorePointer(
                    ignoring: isRefreshing,
                    sliver: _Results(
                      onViewDetails: _openDetails,
                      onCompare: canCompare ? _addToCompare : null,
                      compareIds: compareIds,
                    ),
                  ),
                ),
              },
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
  const _Controls({
    required this.search,
    required this.isRefreshing,
    required this.onQueryChanged,
  });

  final TextEditingController search;
  final bool isRefreshing;
  final ValueChanged<String> onQueryChanged;

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
                CatalogSearchField(
                  controller: search,
                  onChanged: onQueryChanged,
                ),
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

class _Results extends ConsumerWidget {
  const _Results({
    required this.onViewDetails,
    required this.onCompare,
    required this.compareIds,
  });

  final ValueChanged<Paddle> onViewDetails;
  final ValueChanged<Paddle>? onCompare;
  final List<String> compareIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(
      catalogControllerProvider.select(
        (state) => state.value?.paddles.isEmpty ?? false,
      ),
    );
    if (!isEmpty) {
      return PaddleGrid(
        onViewDetails: onViewDetails,
        onCompare: onCompare,
        compareIds: compareIds,
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: StateMessage(
        icon: Icons.search_off,
        title: 'No paddles found',
        message: 'Try a different search or adjust your filters.',
        action: OutlinedButton(
          onPressed: () => CatalogRoute.fromFilter(
            ref.read(catalogFilterProvider).cleared(),
            compare: ref.read(compareIdsProvider),
          ).goInPlace(context),
          child: const Text('Clear filters'),
        ),
      ),
    );
  }
}
