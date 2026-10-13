import 'package:flutter/widgets.dart';

@immutable
class CardGridLayout {
  const CardGridLayout({
    required this.columns,
    required this.padding,
    required this.columnGap,
    required this.rowGap,
  });

  final int columns;
  final EdgeInsets padding;
  final double columnGap;
  final double rowGap;
}
