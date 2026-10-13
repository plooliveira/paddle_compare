import 'package:material_ui/material_ui.dart';

import '../../widgets/paddle_detail_image.dart';

class PaddleDetailSkeleton extends StatefulWidget {
  const PaddleDetailSkeleton({super.key});

  @override
  State<PaddleDetailSkeleton> createState() => _PaddleDetailSkeletonState();
}

class _PaddleDetailSkeletonState extends State<PaddleDetailSkeleton>
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
    final block = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget bar(double width, double height) =>
        _Bar(width: width, height: height, color: block);
    Widget tiles() => Row(
      children: [
        Expanded(child: bar(double.infinity, 64)),
        const SizedBox(width: 8),
        Expanded(child: bar(double.infinity, 64)),
      ],
    );

    return Semantics(
      label: 'Loading paddle',
      child: ExcludeSemantics(
        child: FadeTransition(
          opacity: _opacity,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: PaddleDetailImage.defaultMaxHeight,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: bar(double.infinity, double.infinity),
                  ),
                ),
                const SizedBox(height: 24),
                bar(64, 8),
                const SizedBox(height: 14),
                bar(double.infinity, 26),
                const SizedBox(height: 8),
                bar(180, 26),
                const SizedBox(height: 18),
                bar(96, 18),
                const SizedBox(height: 20),
                bar(double.infinity, 12),
                const SizedBox(height: 8),
                bar(220, 12),
                const SizedBox(height: 36),
                bar(72, 8),
                const SizedBox(height: 14),
                tiles(),
                const SizedBox(height: 8),
                tiles(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    ),
  );
}
