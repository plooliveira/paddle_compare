import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/compare/view/widgets/compare_tray.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/app/paddle_detail/view/paddle_detail_view.dart';
import 'package:paddle_compare/app/paddle_detail/view/mobile/widgets/paddle_detail_skeleton.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../../../../helpers/fake_paddle_repository.dart';
import '../../../../helpers/finders.dart';
import '../../../../helpers/paddles.dart';
import '../../../../helpers/pump_app.dart';

Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/paddles/summit',
}) => pumpApp(tester, repository, location: location);

final _compareButton = button('Add to compare');

Future<void> _openFullSpecs(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Full specifications'));
  await tester.tap(find.text('Full specifications'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a skeleton and a disabled compare button while loading', (
    tester,
  ) async {
    final repository = FakePaddleRepository([fullPaddle])
      ..gate = Completer<void>();
    await _pumpPage(tester, repository);

    expect(find.byType(PaddleDetailSkeleton), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(isEnabled(tester, _compareButton), isFalse);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailSkeleton), findsNothing);
    expect(find.text('Summit Pro 16'), findsOneWidget);
    expect(isEnabled(tester, _compareButton), isTrue);
  });

  testWidgets(
    'add to compare goes back to the filtered catalog, into its tray',
    (tester) async {
      final repository = FakePaddleRepository([fullPaddle]);
      final router = await _pumpPage(
        tester,
        repository,
        location: '/?sort=price-asc',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();

      expect(currentUrl(router), '/paddles/summit?sort=price-asc');
      expect(repository.ids, ['summit']);
      final queries = repository.queries.length;

      await tester.tap(_compareButton);
      await tester.pumpAndSettle();

      expect(currentUrl(router), '/?sort=price-asc&compare=summit');
      expect(find.byType(PaddleDetailView), findsNothing);
      expect(inTray(find.text('Summit Pro 16')), findsOneWidget);
      expect(find.text('Lowest price'), findsOneWidget);
      // The catalog didn't reload; the tray asked for its own paddle.
      expect(repository.queries, hasLength(queries));
      expect(repository.ids, ['summit', 'summit']);
    },
  );

  testWidgets('from a shared link, add to compare goes to the catalog', (
    tester,
  ) async {
    final router = await _pumpPage(tester, FakePaddleRepository([fullPaddle]));
    await tester.pumpAndSettle();

    await tester.tap(_compareButton);
    await tester.pumpAndSettle();

    expect(currentUrl(router), '/?compare=summit');
    expect(find.byType(PaddleDetailView), findsNothing);
    expect(find.byType(CompareTray), findsOneWidget);
  });

  testWidgets('says when the paddle is already in the comparison', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      FakePaddleRepository([fullPaddle]),
      location: '/paddles/summit?compare=summit',
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to compare'), findsNothing);
    expect(
      tester.widget<ButtonStyleButton>(button('Added to compare')).enabled,
      isFalse,
    );
    expect(
      find.descendant(
        of: button('Added to compare'),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
  });

  testWidgets('says when the comparison is full', (tester) async {
    await _pumpPage(
      tester,
      FakePaddleRepository([fullPaddle]),
      location: '/paddles/summit?compare=a&compare=b',
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to compare'), findsNothing);
    expect(
      tester.widget<ButtonStyleButton>(button('Compare is full')).enabled,
      isFalse,
    );
  });

  testWidgets('completing the comparison opens it', (tester) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository([fullPaddle]),
      location: '/paddles/summit?compare=other',
    );
    await tester.pumpAndSettle();

    await tester.tap(_compareButton);
    await tester.pumpAndSettle();

    expect(currentUrl(router), '/compare?compare=other&compare=summit');
    expect(find.byType(PaddleDetailView), findsNothing);
    expect(find.byType(CompareView), findsOneWidget);
  });

  testWidgets('highlights the key specs and the ratings', (tester) async {
    await _pumpPage(tester, FakePaddleRepository([fullPaddle]));
    await tester.pumpAndSettle();

    expect(find.text('APEX COURT'), findsOneWidget);
    expect(find.text('\$249.99'), findsOneWidget);
    expect(find.text('In stock'), findsOneWidget);
    expect(find.text(fullPaddle.description!), findsOneWidget);

    expect(find.text('Elongated'), findsOneWidget);
    expect(find.text('8.0 oz · 227 g', findRichText: true), findsOneWidget);
    expect(find.text('16 mm'), findsOneWidget);
    expect(find.text('Raw carbon'), findsOneWidget);

    await tester.ensureVisible(find.text('Pop'));
    await tester.pump();
    for (final (label, value) in [
      ('Power', '7 out of 10'),
      ('Control', '8 out of 10'),
      ('Spin', '9 out of 10'),
      ('Pop', '6 out of 10'),
    ]) {
      expect(
        tester.getSemantics(find.text(label)),
        matchesSemantics(label: label, value: value),
      );
    }
  });

  testWidgets('the full specifications start collapsed and open on tap', (
    tester,
  ) async {
    await _pumpPage(tester, FakePaddleRepository([fullPaddle]));
    await tester.pumpAndSettle();

    expect(find.text('Length'), findsNothing);

    await _openFullSpecs(tester);

    for (final (label, value) in [
      ('Length', '16.5 in'),
      ('Width', '7.5 in'),
      ('Handle length', '5.5 in'),
      ('Grip circumference', '4.25 in'),
      ('Swing weight', '116'),
      ('Twist weight', '6.4'),
      ('Release year', '2025'),
    ]) {
      expect(find.text(label), findsOneWidget);
      expect(find.text(value), findsOneWidget);
    }
  });

  testWidgets('says which specs are missing instead of hiding them', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      FakePaddleRepository([sparsePaddle]),
      location: '/paddles/sparse',
    );
    await tester.pumpAndSettle();

    expect(find.text('Price unavailable'), findsOneWidget);
    expect(find.text('In stock'), findsNothing);
    expect(find.text('Sold out'), findsNothing);
    // Four tiles and three ratings.
    expect(find.text('—'), findsNWidgets(7));
    await tester.ensureVisible(find.text('Spin'));
    await tester.pump();
    expect(
      tester.getSemantics(find.text('Spin')),
      matchesSemantics(label: 'Spin', value: 'Not listed'),
    );

    await _openFullSpecs(tester);

    expect(find.text('Not listed'), findsNWidgets(7));
  });

  testWidgets('shows a sold-out paddle as such', (tester) async {
    await _pumpPage(
      tester,
      FakePaddleRepository([fullPaddle.copyWith(inStock: false)]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sold out'), findsOneWidget);
    expect(find.text('In stock'), findsNothing);
  });

  testWidgets('an unknown id offers the way back to the catalog', (
    tester,
  ) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository([fullPaddle]),
      location: '/paddles/nope',
    );
    await tester.pumpAndSettle();

    expect(find.text('Paddle not found'), findsOneWidget);
    expect(find.text('Add to compare'), findsNothing);

    await tester.tap(find.text('Browse paddles'));
    await tester.pumpAndSettle();

    expect(currentUrl(router), '/');
    expect(find.text('Paddle not found'), findsNothing);
  });

  testWidgets('shows an error with a retry that reloads', (tester) async {
    final repository = FakePaddleRepository([fullPaddle])
      ..error = const PaddleRepositoryException('down');
    await _pumpPage(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Add to compare'), findsNothing);
    expect(find.byType(BackButton), findsOneWidget);

    repository.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Summit Pro 16'), findsOneWidget);
  });

  testWidgets('going to another paddle reuses the page and loads it', (
    tester,
  ) async {
    final repository = FakePaddleRepository([fullPaddle, sparsePaddle]);
    final router = await _pumpPage(tester, repository);
    await tester.pumpAndSettle();

    router.go('/paddles/sparse');
    await tester.pumpAndSettle();

    expect(find.text('Sparse'), findsOneWidget);
    expect(find.text('Summit Pro 16'), findsNothing);
    expect(repository.ids, ['summit', 'sparse']);
  });
}
