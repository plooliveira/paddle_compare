import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/catalog/view/desktop/catalog_desktop_page.dart';
import 'package:paddle_compare/app/catalog/view/mobile/catalog_mobile_page.dart';
import 'package:paddle_compare/app/compare/view/widgets/compare_tray.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card_skeleton.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../../../../helpers/catalog_pages.dart';
import '../../../../helpers/fake_paddle_repository.dart';
import '../../../../helpers/url_reports.dart';

const _desktop = Size(1280, 800);

Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/',
}) => pumpCatalogPage(
  tester,
  repository,
  location: location,
  size: _desktop,
  devicePixelRatio: 1,
);

Uri _url(GoRouter router) => router.routerDelegate.currentConfiguration.uri;

String _searchText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

Finder _inTray(Finder finder) =>
    find.descendant(of: find.byType(CompareTray), matching: finder);

Finder _inComparison(Finder finder) =>
    find.descendant(of: find.byType(CompareView), matching: finder);

Finder _cardButton(String name, String label) => find.descendant(
  of: find.widgetWithText(PaddleCard, name),
  matching: find.text(label),
);

bool _cardButtonEnabled(WidgetTester tester, String name, String label) =>
    tester
        .widget<OutlinedButton>(
          find.ancestor(
            of: _cardButton(name, label),
            matching: find.bySubtype<OutlinedButton>(),
          ),
        )
        .enabled;

/// Centers the button labeled [label] on the card showing [name]. A whole
/// card can be taller than the grid's viewport.
Future<void> _scrollTo(WidgetTester tester, String name, String label) async {
  await Scrollable.ensureVisible(
    tester.element(
      find.descendant(
        of: find.widgetWithText(PaddleCard, name, skipOffstage: false),
        matching: find.text(label, skipOffstage: false),
      ),
    ),
    alignment: 0.5,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows skeletons while loading, then three cards per row', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(6))
      ..gate = Completer<void>();
    await _pumpPage(tester, repository);

    expect(find.byType(CatalogDesktopPage), findsOneWidget);
    expect(find.byType(PaddleCardSkeleton), findsWidgets);
    expect(find.text('Loading…'), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(PaddleCardSkeleton), findsNothing);
    expect(find.text('6 paddles'), findsOneWidget);

    Offset at(String name) =>
        tester.getTopLeft(find.text(name, skipOffstage: false));
    final first = at('Paddle 0');
    expect(at('Paddle 1').dy, first.dy);
    expect(at('Paddle 2').dy, first.dy);
    expect(at('Paddle 1').dx, greaterThan(first.dx));
    expect(at('Paddle 2').dx, greaterThan(at('Paddle 1').dx));
    expect(at('Paddle 3').dx, first.dx);
    expect(at('Paddle 3').dy, greaterThan(first.dy));
  });

  testWidgets('the sidebar filters in place, and Reset clears it', (
    tester,
  ) async {
    final reports = recordUrlReports(tester);
    final router = await _pumpPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
    );
    await tester.pumpAndSettle();
    reports.clear();

    final reset = find.widgetWithText(TextButton, 'Reset');
    expect(tester.widget<TextButton>(reset).enabled, isFalse);

    await tester.tap(find.widgetWithText(FilterChip, 'Hybrid'));
    await tester.pumpAndSettle();

    expect(_url(router).queryParametersAll, {
      'shape': ['hybrid'],
    });
    expect(reports, [
      allOf(
        containsPair('uri', '/?shape=hybrid'),
        containsPair('replace', true),
      ),
    ]);
    expect(find.text('Paddle 1'), findsOneWidget);
    expect(find.text('Paddle 0'), findsNothing);
    expect(find.text('2 paddles'), findsOneWidget);

    await tester.tap(reset);
    await tester.pumpAndSettle();

    expect(_url(router).toString(), '/');
    expect(find.text('Paddle 0'), findsOneWidget);
    expect(tester.widget<TextButton>(reset).enabled, isFalse);
  });

  testWidgets('the sort menu reorders the grid', (tester) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sort: Featured'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: High to Low'));
    await tester.pumpAndSettle();

    expect(_url(router).queryParameters, {'sort': 'price-desc'});
    expect(find.text('Sort: Price: High to Low'), findsOneWidget);
    expect(find.byType(RadioMenuButton<PaddleSort>), findsNothing);
    final first = tester.getTopLeft(find.text('Paddle 4'));
    final second = tester.getTopLeft(find.text('Paddle 3'));
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
  });

  testWidgets('the sort menu marks the current order', (tester) async {
    await _pumpPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
      location: '/?sort=power',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Sort by Power: High to Low'));
    await tester.pumpAndSettle();

    final checked = tester
        .widgetList<RadioMenuButton<PaddleSort>>(
          find.byType(RadioMenuButton<PaddleSort>),
        )
        .where((button) => button.value == button.groupValue)
        .map((button) => button.value);
    expect(checked, [PaddleSort.power]);
  });

  testWidgets('the tray has three slots; the third paddle opens them', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(6));
    final router = await _pumpPage(
      tester,
      repository,
      location: '/?compare=p0&compare=p1',
    );
    await tester.pumpAndSettle();

    expect(_inTray(find.text('Paddle 0')), findsOneWidget);
    expect(_inTray(find.text('Paddle 1')), findsOneWidget);
    expect(_inTray(find.text('Add a paddle')), findsOneWidget);
    expect(_cardButtonEnabled(tester, 'Paddle 2', 'Compare'), isTrue);

    await _scrollTo(tester, 'Paddle 2', 'Compare');
    await tester.tap(_cardButton('Paddle 2', 'Compare'));
    await tester.pumpAndSettle();

    expect(
      _url(router).toString(),
      '/compare?compare=p0&compare=p1&compare=p2',
    );
    // A page of its own on desktop, with all three paddles.
    expect(find.byType(CompareView), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    for (final name in ['Paddle 0', 'Paddle 1', 'Paddle 2']) {
      expect(_inComparison(find.text(name)), findsOneWidget);
    }

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(_inTray(find.text('Paddle 2')), findsOneWidget);
    expect(_inTray(find.text('Add a paddle')), findsNothing);
    expect(_cardButtonEnabled(tester, 'Paddle 2', 'Added'), isFalse);
    await _scrollTo(tester, 'Paddle 3', 'Compare');
    expect(_cardButtonEnabled(tester, 'Paddle 3', 'Compare'), isFalse);
    expect(repository.ids, ['p0', 'p1', 'p2']);
  });

  testWidgets('shows an error with a retry that reloads', (tester) async {
    final repository = FakePaddleRepository(catalogPaddles(5))
      ..error = const PaddleRepositoryException('down');
    await _pumpPage(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);

    repository.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Paddle 0'), findsOneWidget);
  });

  testWidgets('the empty state clears the filters and the search field', (
    tester,
  ) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
      location: '/?q=nothing%20like%20this&shape=hybrid',
    );
    await tester.pumpAndSettle();

    expect(find.text('No paddles found'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();

    expect(find.text('Paddle 0'), findsOneWidget);
    expect(_searchText(tester), isEmpty);
    expect(_url(router).toString(), '/');
  });

  testWidgets('fits at the narrowest desktop width, in a short window', (
    tester,
  ) async {
    // Any overflow fails the test.
    await pumpCatalogPage(
      tester,
      FakePaddleRepository(catalogPaddles(9)),
      location: '/?sort=power&in-stock=true&compare=p0&compare=p1&compare=p2',
      size: const Size(840, 560),
      devicePixelRatio: 1,
    );
    await tester.pumpAndSettle();

    expect(find.byType(CatalogDesktopPage), findsOneWidget);
    expect(find.text('Sort: Power: High to Low'), findsOneWidget);
    expect(find.byType(PaddleCard), findsWidgets);
    expect(_inTray(find.text('Paddle 2')), findsOneWidget);
  });

  testWidgets('a resize to a phone swaps the layout and keeps the state', (
    tester,
  ) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Hybrid'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'paddle 3');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(_url(router).queryParametersAll, {
      'q': ['paddle 3'],
      'shape': ['hybrid'],
    });

    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpAndSettle();

    expect(find.byType(CatalogDesktopPage), findsNothing);
    expect(find.byType(CatalogMobilePage), findsOneWidget);
    expect(_searchText(tester), 'paddle 3');
    expect(find.widgetWithText(InputChip, 'Hybrid'), findsOneWidget);
    expect(find.text('Paddle 3'), findsOneWidget);
    expect(_url(router).queryParametersAll, {
      'q': ['paddle 3'],
      'shape': ['hybrid'],
    });
  });
}
