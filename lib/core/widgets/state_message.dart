import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  static const _maxWidth = 360.0;

  /// Caps the width like a ConstrainedBox would, but also when measuring the
  /// height, which a ConstrainedBox doesn't. SliverFillRemaining sizes the
  /// message by that height, and text measured too wide wraps on fewer lines
  /// than it will take.
  static BoxConstraints _capWidth(BoxConstraints constraints) => constraints
      .loosen()
      .copyWith(maxWidth: math.min(constraints.maxWidth, _maxWidth));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstraintsTransformBox(
        constraintsTransform: _capWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Icon(icon, size: 26, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (action case final action?) ...[
                const SizedBox(height: 28),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
