import 'package:material_ui/material_ui.dart';

import '../../widgets/paddle_card_skeleton.dart';
import 'two_column_sliver.dart';

class CatalogLoadingSliver extends StatefulWidget {
  const CatalogLoadingSliver({super.key});

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
      sliver: TwoColumnSliver(
        itemCount: 6,
        itemBuilder: (context, index) => const PaddleCardSkeleton(),
      ),
    );
  }
}
