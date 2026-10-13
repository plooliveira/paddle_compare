import 'package:material_ui/material_ui.dart';

class CompareBar extends StatelessWidget {
  const CompareBar({super.key, required this.onCompare});

  final VoidCallback? onCompare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCompare,
              icon: const Icon(Icons.compare_arrows, size: 20),
              label: const Text('Add to compare'),
            ),
          ),
        ),
      ),
    );
  }
}
