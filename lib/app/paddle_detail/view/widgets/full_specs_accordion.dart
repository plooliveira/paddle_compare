import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/paddle/paddle_repository.dart';
import 'full_specs_list.dart';

class FullSpecsAccordion extends StatelessWidget {
  const FullSpecsAccordion({super.key, required this.paddle});

  final Paddle paddle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Divider(),
        ExpansionTile(
          title: Text('Full specifications', style: theme.textTheme.titleSmall),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: [FullSpecsList(paddle: paddle)],
        ),
        const Divider(),
      ],
    );
  }
}
