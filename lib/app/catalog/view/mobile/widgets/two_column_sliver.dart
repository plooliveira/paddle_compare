import 'package:material_ui/material_ui.dart';

/// Lazy two-column grid. Each row sizes to its tallest card, which a fixed
/// `childAspectRatio` can't do once the text scale grows.
class TwoColumnSliver extends StatelessWidget {
  const TwoColumnSliver({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.footer,
  });

  static const columnGap = 12.0;
  static const rowGap = 24.0;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Built lazily like the rows, only once it scrolls near the viewport.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final rowCount = (itemCount / 2).ceil();
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      sliver: SliverList.builder(
        itemCount: rowCount + (footer == null ? 0 : 1),
        itemBuilder: (context, row) {
          if (row == rowCount) return footer;
          final first = row * 2;
          return Padding(
            padding: const EdgeInsets.only(bottom: rowGap),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: itemBuilder(context, first)),
                  const SizedBox(width: columnGap),
                  Expanded(
                    child: first + 1 < itemCount
                        ? itemBuilder(context, first + 1)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
