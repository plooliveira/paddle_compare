import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/core/widgets/skeleton_pulse.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../../../../helpers/fake_paddle_repository.dart';
import '../../../../helpers/finders.dart';
import '../../../../helpers/paddles.dart';
import '../../../../helpers/pump_app.dart';

const _other = Paddle(id: 'other', brand: 'Brand', name: 'Other');

/// Opens the sheet at `/compare?compare=…`, over the catalog and its tray.
Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository,
  List<String> ids,
) => pumpApp(
  tester,
  repository,
  location: Uri(path: '/compare', queryParameters: {'compare': ids}).toString(),
);

Finder _text(String text) => inComparison(find.text(text));

final _selectPaddle = _text('Select paddle');

void main() {
  testWidgets('shows the paddle on the left and an empty slot on the right', (
    tester,
  ) async {
    final repository = FakePaddleRepository([fullPaddle])
      ..gate = Completer<void>();
    await _pumpPage(tester, repository, ['summit']);

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(inComparison(find.byType(SkeletonPulse)), findsOneWidget);
    expect(_selectPaddle, findsOneWidget);
    expect(_text('Compare'), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(inComparison(find.byType(SkeletonPulse)), findsNothing);
    expect(_text('APEX COURT'), findsOneWidget);
    expect(_text('Summit Pro 16'), findsOneWidget);
    expect(_text('\$249.99'), findsOneWidget);
    expect(
      tester.getTopLeft(_text('Summit Pro 16')).dx,
      lessThan(tester.getTopLeft(_selectPaddle).dx),
    );
  });

  testWidgets('lists the specs of each paddle', (tester) async {
    await _pumpPage(tester, FakePaddleRepository([fullPaddle]), ['summit']);
    await tester.pumpAndSettle();

    for (final value in [
      'Elongated',
      '8.0 oz · 227 g',
      '16 mm',
      'Raw carbon',
      '16.5 in',
      '7.5 in',
      '5.5 in',
      '4.25 in',
      '116',
      '6.4',
      '2025',
    ]) {
      expect(_text(value), findsOneWidget, reason: value);
    }

    for (final (rating, value) in [
      ('7', '7 out of 10'),
      ('8', '8 out of 10'),
      ('9', '9 out of 10'),
      ('6', '6 out of 10'),
    ]) {
      await tester.ensureVisible(_text(rating));
      await tester.pump();
      expect(
        tester.getSemantics(_text(rating)),
        matchesSemantics(label: 'Summit Pro 16', value: value),
      );
    }
  });

  testWidgets('says which specs are missing', (tester) async {
    await _pumpPage(tester, FakePaddleRepository([sparsePaddle]), ['sparse']);
    await tester.pumpAndSettle();

    expect(_text('Price unavailable'), findsOneWidget);
    // Four key specs, three ratings and seven in the full specifications.
    expect(_text('—'), findsNWidgets(14));
    expect(
      tester.getSemantics(_text('—').first),
      matchesSemantics(label: 'Sparse', value: 'Not listed'),
    );
  });

  testWidgets('shows two paddles side by side, and no empty slot', (
    tester,
  ) async {
    await _pumpPage(tester, FakePaddleRepository([fullPaddle, sparsePaddle]), [
      'summit',
      'sparse',
    ]);
    await tester.pumpAndSettle();

    expect(_text('Summit Pro 16'), findsOneWidget);
    expect(_text('Sparse'), findsOneWidget);
    expect(_selectPaddle, findsNothing);
    expect(
      tester.getTopLeft(_text('Summit Pro 16')).dx,
      lessThan(tester.getTopLeft(_text('Sparse')).dx),
    );
  });

  testWidgets('a phone shows the first two of three paddles', (tester) async {
    final repository = FakePaddleRepository([fullPaddle, sparsePaddle, _other]);
    await _pumpPage(tester, repository, ['summit', 'sparse', 'other']);
    await tester.pumpAndSettle();

    expect(_text('Summit Pro 16'), findsOneWidget);
    expect(_text('Sparse'), findsOneWidget);
    expect(_text('Other'), findsNothing);
    expect(repository.ids, ['summit', 'sparse']);
  });

  testWidgets('select paddle closes the sheet, to pick one in the catalog', (
    tester,
  ) async {
    final router = await _pumpPage(tester, FakePaddleRepository([fullPaddle]), [
      'summit',
    ]);
    await tester.pumpAndSettle();

    await tester.tap(_selectPaddle);
    await tester.pumpAndSettle();

    expect(find.byType(CompareView), findsNothing);
    expect(currentUrl(router), '/?compare=summit');
  });
}
