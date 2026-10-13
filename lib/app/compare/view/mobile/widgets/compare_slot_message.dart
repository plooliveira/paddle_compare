import 'package:material_ui/material_ui.dart';

import 'compare_slot_header.dart';

class CompareSlotMessage extends StatelessWidget {
  const CompareSlotMessage({
    super.key,
    required this.icon,
    required this.title,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AspectRatio(
      aspectRatio: CompareSlotHeader.imageAspectRatio,
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
