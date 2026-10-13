import 'package:material_ui/material_ui.dart';

import 'card_grid_layout.dart';

class CardGridSliver extends StatelessWidget {
  const CardGridSliver({
    super.key,
    required this.layout,
    required this.itemCount,
    required this.itemBuilder,
    this.footer,
  });

  final CardGridLayout layout;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final columns = layout.columns;
    final rowCount = (itemCount / columns).ceil();
    return SliverPadding(
      padding: layout.padding,
      sliver: SliverList.builder(
        itemCount: rowCount + (footer == null ? 0 : 1),
        itemBuilder: (context, row) {
          if (row == rowCount) return footer;
          final first = row * columns;
          return Padding(
            padding: EdgeInsets.only(bottom: layout.rowGap),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) SizedBox(width: layout.columnGap),
                    Expanded(
                      child: first + column < itemCount
                          ? itemBuilder(context, first + column)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
