import 'package:material_ui/material_ui.dart';

import 'compare_slot_skeleton.dart';

class EmptyCompareSlot extends StatelessWidget {
  const EmptyCompareSlot({
    super.key,
    required this.onSelect,
    this.imageMaxHeight = double.infinity,
  });

  final VoidCallback onSelect;
  final double imageMaxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    const shape = BorderRadius.all(Radius.circular(4));
    return CompareSlotSkeleton(
      imageMaxHeight: imageMaxHeight,
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
