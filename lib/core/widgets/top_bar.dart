import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/core/widgets/fading_back_button.dart';

class TopBar extends StatelessWidget {
  const TopBar({required this.margin});

  /// Lines the arrow up with the margin rather than the button's edge.
  static const _backButtonInset = 8.0;

  final double margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            margin - _backButtonInset,
            12,
            margin,
            12,
          ),
          child: Row(
            children: [
              const FadingBackButton(),
              const SizedBox(width: 4),
              Text('Paddles', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
