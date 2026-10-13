import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../compare/controller/compare_controller.dart';
import '../../../../compare/controller/compare_limits.dart';
import '../../../../router.dart';

/// Adds the paddle to the comparison and stays on the page, whose tray then
/// shows it. The paddle that completes the comparison opens it instead.
/// Removing is the tray's job, so the other states point there.
class CompareAction extends ConsumerWidget {
  const CompareAction({super.key, required this.paddleId});

  /// Null while the paddle loads, which disables the button.
  final String? paddleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ids = ref.watch(compareIdsProvider);
    final id = paddleId;
    const limit = CompareLimits.desktop;

    var label = 'Add to compare';
    var icon = Icons.compare_arrows;
    String? hint;
    VoidCallback? onPressed;
    if (id != null && ids.contains(id)) {
      label = 'Added to compare';
      icon = Icons.check;
      hint = 'Remove it from the tray below';
    } else if (ids.length >= limit) {
      label = 'Compare is full';
      hint = 'Remove a paddle from the tray to add this one';
    } else {
      if (ids.isNotEmpty) hint = '${ids.length} of $limit in compare';
      if (id != null) {
        onPressed = () =>
            CatalogRoute.of(context)
                .addToCompare(context, id, limit: limit, stayOnPage: true);
      }
    }

    return Row(
      children: [
        FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label),
        ),
        if (hint != null) ...[
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
