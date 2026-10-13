import 'package:material_ui/material_ui.dart';

import 'compare_slot_skeleton.dart';

/// A column with no paddle yet: the outline of one, and the way to pick it.
/// The whole illustration block is the button, so it is easy to hit.
class EmptyCompareSlot extends StatelessWidget {
  const EmptyCompareSlot({super.key, required this.onSelect});

  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    const shape = BorderRadius.all(Radius.circular(4));
    return CompareSlotSkeleton(
      image: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.outlineVariant),
          borderRadius: shape,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelect,
          child: Semantics(
            button: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.onSurface),
                      ),
                      child: Icon(Icons.add, size: 22, color: colors.onSurface),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Select paddle',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
