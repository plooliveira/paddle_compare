import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../../../core/widgets/adaptive_view.dart';
import '../controller/compare_controller.dart';
import 'mobile/compare_mobile_page.dart';

class CompareView extends StatefulWidget {
  const CompareView({super.key, required this.ids});

  final List<String> ids;

  @override
  State<CompareView> createState() => _CompareViewState();
}

class _CompareViewState extends State<CompareView> {
  late final _container = ProviderContainer(
    parent: ProviderScope.containerOf(context, listen: false),
    overrides: _overrides,
  );

  List<Override> get _overrides => [
    compareIdsProvider.overrideWithValue(widget.ids),
  ];

  @override
  void didUpdateWidget(CompareView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(widget.ids, oldWidget.ids)) return;
    // Applied after this frame, like CatalogView: anything sharing the
    // container from outside this subtree must not be marked dirty while the
    // tree is building.
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
        mobile: (_) => const CompareMobilePage(),
        // TODO: desktop variant. The mobile one stands in until then.
        desktop: (_) => const CompareMobilePage(),
      ),
    );
  }
}
