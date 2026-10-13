import 'package:material_ui/material_ui.dart';

class FadingBackButton extends StatelessWidget {
  const FadingBackButton({super.key});

  static const curve = Interval(0.4, 1, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || !route.impliesAppBarDismissal) {
      return const SizedBox.shrink();
    }
    final animation = route.animation;
    if (animation == null) return const BackButton();
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: curve)),
      child: const BackButton(),
    );
  }
}
