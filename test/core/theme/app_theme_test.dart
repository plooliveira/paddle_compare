import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoPageTransitionsBuilder;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/core/theme/app_theme.dart';

void main() {
  test('pages slide in from the right on phones', () {
    final builders = AppTheme.light().pageTransitionsTheme.builders;

    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      expect(
        builders[platform],
        isA<CupertinoPageTransitionsBuilder>(),
        reason: '$platform',
      );
    }
  });
}
