import 'package:material_ui/material_ui.dart';

class CatalogHeader extends StatelessWidget {
  const CatalogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PADDLE COMPARE', style: theme.textTheme.labelSmall),
          const SizedBox(height: 10),
          Semantics(
            header: true,
            child: Text('The Collection', style: theme.textTheme.displaySmall),
          ),
          const SizedBox(height: 8),
          Text(
            'Find the paddle that fits your game.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
