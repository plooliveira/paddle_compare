import 'package:material_ui/material_ui.dart';

class CompareSection extends StatelessWidget {
  const CompareSection({super.key, required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 4),
        for (final (index, row) in rows.indexed) ...[
          if (index > 0) const Divider(),
          row,
        ],
      ],
    );
  }
}
