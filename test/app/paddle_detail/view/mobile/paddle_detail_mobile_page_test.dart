import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/paddle_detail/view/widgets/paddle_detail_skeleton.dart';
import 'package:paddle_compare/app/router.dart';
import 'package:paddle_compare/core/theme/app_theme.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import '../../../../helpers/fake_paddle_repository.dart';

const _full = Paddle(
  id: 'summit',
  brand: 'Apex Court',
  name: 'Summit Pro 16',
  releaseYear: 2025,
  priceUsd: 249.99,
  inStock: true,
  shape: PaddleShape.elongated,
  faceMaterial: 'raw carbon',
  coreThicknessMm: 16,
  weightOz: 8,
  swingWeight: 116,
  twistWeight: 6.4,
  dimensions: PaddleDimensions(
    lengthIn: 16.5,
    widthIn: 7.5,
    handleLengthIn: 5.5,
  ),
  gripCircumferenceIn: 4.25,
  ratings: PaddleRatings(power: 7, control: 8, spin: 9, pop: 6),
  description: 'Tour-level control paddle with a thick core.',
);

/// Only the required fields and one rating.
const _sparse = Paddle(
  id: 'sparse',
  brand: 'Brand',
  name: 'Sparse',
  ratings: PaddleRatings(power: 5),
);

Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/paddles/summit',
}) async {
  tester.view.physicalSize = const Size(375, 812) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final router = GoRouter(routes: $appRoutes, initialLocation: location);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [paddleRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pump();
  return router;
}

Uri _url(GoRouter router) => router.routerDelegate.currentConfiguration.uri;

final _compareButton = find.ancestor(
  of: find.text('Add to compare'),
  matching: find.bySubtype<ButtonStyleButton>(),
);

bool _compareEnabled(WidgetTester tester) =>
    tester.widget<ButtonStyleButton>(_compareButton).enabled;

Future<void> _openFullSpecs(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Full specifications'));
  await tester.tap(find.text('Full specifications'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a skeleton and a disabled compare button while loading', (
    tester,
  ) async {
    final repository = FakePaddleRepository([_full])..gate = Completer<void>();
    await _pumpPage(tester, repository);

    expect(find.byType(PaddleDetailSkeleton), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(_compareEnabled(tester), isFalse);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailSkeleton), findsNothing);
    expect(find.text('Summit Pro 16'), findsOneWidget);
    expect(_compareEnabled(tester), isTrue);
  });

  testWidgets('highlights the key specs and the ratings', (tester) async {
    await _pumpPage(tester, FakePaddleRepository([_full]));
    await tester.pumpAndSettle();

    expect(find.text('APEX COURT'), findsOneWidget);
    expect(find.text('\$249.99'), findsOneWidget);
    expect(find.text('In stock'), findsOneWidget);
    expect(find.text(_full.description!), findsOneWidget);

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
    await _pumpPage(tester, FakePaddleRepository([_full]));
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
      FakePaddleRepository([_sparse]),
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
      FakePaddleRepository([_full.copyWith(inStock: false)]),
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
      FakePaddleRepository([_full]),
      location: '/paddles/nope',
    );
    await tester.pumpAndSettle();

    expect(find.text('Paddle not found'), findsOneWidget);
    expect(find.text('Add to compare'), findsNothing);

    await tester.tap(find.text('Browse paddles'));
    await tester.pumpAndSettle();

    expect(_url(router).path, '/');
    expect(find.text('Paddle not found'), findsNothing);
  });

  testWidgets('shows an error with a retry that reloads', (tester) async {
    final repository = FakePaddleRepository([_full])
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
    final repository = FakePaddleRepository([_full, _sparse]);
    final router = await _pumpPage(tester, repository);
    await tester.pumpAndSettle();

    router.go('/paddles/sparse');
    await tester.pumpAndSettle();

    expect(find.text('Sparse'), findsOneWidget);
    expect(find.text('Summit Pro 16'), findsNothing);
    expect(repository.ids, ['summit', 'sparse']);
  });
}
