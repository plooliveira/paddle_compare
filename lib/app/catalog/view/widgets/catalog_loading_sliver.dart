import 'package:material_ui/material_ui.dart';

import 'card_grid_layout.dart';
import 'card_grid_sliver.dart';
import 'paddle_card_skeleton.dart';

class CatalogLoadingSliver extends StatefulWidget {
  const CatalogLoadingSliver({super.key, required this.layout});

  final CardGridLayout layout;

  @override
  State<CatalogLoadingSliver> createState() => _CatalogLoadingSliverState();
}

class _CatalogLoadingSliverState extends State<CatalogLoadingSliver>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
    value: 1,
  );
  late final _opacity = Tween<double>(
    begin: 0.45,
    end: 1,
  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.value = 1;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFadeTransition(
      opacity: _opacity,
      sliver: CardGridSliver(
        layout: widget.layout,
        itemCount: widget.layout.columns * 3,
        itemBuilder: (context, index) => const PaddleCardSkeleton(),
      ),
    );
  }
}
