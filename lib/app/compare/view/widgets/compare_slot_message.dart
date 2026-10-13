import 'package:material_ui/material_ui.dart';

import 'compare_slot_image_box.dart';

class CompareSlotMessage extends StatelessWidget {
  const CompareSlotMessage({
    super.key,
    required this.icon,
    required this.title,
    this.action,
    this.imageMaxHeight = double.infinity,
  });

  final IconData icon;
  final String title;
  final Widget? action;

  /// The message takes the place of the image, in a box of the same size.
  final double imageMaxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return CompareSlotImageBox(
      maxHeight: imageMaxHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 26, color: colors.onSurfaceVariant),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
                if (action case final action?) ...[
                  const SizedBox(height: 8),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
