import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../compare/controller/compare_controller.dart';
import '../../../router.dart';
import '../../controller/catalog_controller.dart';

class CatalogSearchField extends ConsumerStatefulWidget {
  const CatalogSearchField({super.key});

  @override
  ConsumerState<CatalogSearchField> createState() => _CatalogSearchFieldState();
}

class _CatalogSearchFieldState extends ConsumerState<CatalogSearchField> {
  static const _searchDebounce = Duration(milliseconds: 300);

  late final _controller = TextEditingController(
    text: ref.read(catalogFilterProvider).query,
  );
  Timer? _searchTimer;

  String? _sentQuery;

  @override
  void dispose() {
    _searchTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
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

  @override
  Widget build(BuildContext context) {
    // Keeps the field in sync when the search changes elsewhere (e.g. "Clear
    // filters"), and drops a pending search that would undo that change.
    ref.listen(catalogFilterProvider.select((filter) => filter.query), (
      _,
      query,
    ) {
      if (query == _controller.text || query == _sentQuery) return;
      _searchTimer?.cancel();
      _controller.text = query;
    });

    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.search,
      autocorrect: false,
      scrollPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: InputDecoration(
        hintText: 'Search by brand or name',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    _controller.clear();
                    _onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}
