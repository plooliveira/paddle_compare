import 'package:material_ui/material_ui.dart';

class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title.toUpperCase(),
        semanticsLabel: title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
