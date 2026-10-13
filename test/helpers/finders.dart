import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/app/compare/view/widgets/compare_tray.dart';

Finder inTray(Finder finder) =>
    find.descendant(of: find.byType(CompareTray), matching: finder);

/// Only in the comparison: the catalog and its tray underneath show the
/// paddles too.
Finder inComparison(Finder finder) =>
    find.descendant(of: find.byType(CompareView), matching: finder);

/// The button labeled [label].
Finder button(String label) => find.ancestor(
  of: find.text(label),
  matching: find.bySubtype<ButtonStyleButton>(),
);

bool isEnabled(WidgetTester tester, Finder button) =>
    tester.widget<ButtonStyleButton>(button).enabled;

/// The button labeled [label] on the card showing [name].
Finder cardButton(String name, String label) => find.ancestor(
  of: find.descendant(
    of: find.widgetWithText(PaddleCard, name),
    matching: find.text(label),
  ),
  matching: find.bySubtype<ButtonStyleButton>(),
);
