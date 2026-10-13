import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The box at the top of a column, whatever the column shows (paddle,
/// skeleton, empty slot, message), so the columns line up.
///
/// It takes the column's whole width. Its height follows the illustrations'
/// ratio, up to [maxHeight]: every column gets the same box, so paddles drawn
/// to scale stay comparable side by side.
class CompareSlotImageBox extends StatelessWidget {
  const CompareSlotImageBox({
    super.key,
    this.maxHeight = double.infinity,
    required this.child,
  });

  /// The illustrations' own ratio (600×800).
  static const aspectRatio = 3 / 4;

  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        height: math.min(constraints.maxWidth / aspectRatio, maxHeight),
        child: child,
      ),
    );
  }
}
