import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../../../core/widgets/adaptive_view.dart';
import '../controller/paddle_detail_controller.dart';
import 'mobile/paddle_detail_mobile_page.dart';

class PaddleDetailView extends StatefulWidget {
  const PaddleDetailView({super.key, required this.id});

  final String id;

  @override
  State<PaddleDetailView> createState() => _PaddleDetailViewState();
}

class _PaddleDetailViewState extends State<PaddleDetailView> {
  late final _container = ProviderContainer(
    parent: ProviderScope.containerOf(context, listen: false),
    overrides: _overrides,
  );

  List<Override> get _overrides => [
    paddleDetailIdProvider.overrideWithValue(widget.id),
  ];

  @override
  void didUpdateWidget(PaddleDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id == oldWidget.id) return;
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
        mobile: (_) => const PaddleDetailMobilePage(),
        // TODO: desktop variant. The mobile one stands in until then.
        desktop: (_) => const PaddleDetailMobilePage(),
      ),
    );
  }
}
