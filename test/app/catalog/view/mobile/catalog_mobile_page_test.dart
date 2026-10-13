import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/catalog/view/mobile/widgets/filter_sheet.dart';
import 'package:paddle_compare/app/compare/view/widgets/compare_tray.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card_skeleton.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../../../../helpers/catalog_pages.dart';
import '../../../../helpers/fake_paddle_repository.dart';
import '../../../../helpers/url_reports.dart';

Uri _url(GoRouter router) => router.routerDelegate.currentConfiguration.uri;

String _searchText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

double _gridOpacity(WidgetTester tester) =>
    tester.widget<SliverOpacity>(find.byType(SliverOpacity)).opacity;

final _updating = find.bySemanticsLabel('Updating results');

Finder _inTray(Finder finder) =>
    find.descendant(of: find.byType(CompareTray), matching: finder);

Finder _inSheet(Finder finder) =>
    find.descendant(of: find.byType(CompareView), matching: finder);

/// The button of the card showing [name].
Finder _cardButton(String name, String label) => find.descendant(
  of: find.widgetWithText(PaddleCard, name),
  matching: find.text(label),
);

/// Whether the button labeled [label] on the card showing [name] is enabled.
bool _cardButtonEnabled(WidgetTester tester, String name, String label) =>
    tester
        .widget<OutlinedButton>(
          find.ancestor(
            of: _cardButton(name, label),
            matching: find.bySubtype<OutlinedButton>(),
          ),
        )
        .enabled;

/// Centers the card showing [name], clear of the pinned search and the tray.
Future<void> _scrollTo(WidgetTester tester, String name) async {
  await Scrollable.ensureVisible(
    tester.element(find.widgetWithText(PaddleCard, name, skipOffstage: false)),
    alignment: 0.5,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows skeletons while loading, then two cards per row', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(5))
      ..gate = Completer<void>();
    await pumpCatalogPage(tester, repository);

    expect(find.byType(PaddleCardSkeleton), findsWidgets);
    expect(find.text('Loading…'), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(PaddleCardSkeleton), findsNothing);
    expect(find.text('5 paddles'), findsOneWidget);
    expect(find.text('Paddle 0'), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);
    expect(_cardButton('Paddle 0', 'View details'), findsOneWidget);
    expect(_cardButton('Paddle 0', 'Compare'), findsOneWidget);
    expect(_cardButtonEnabled(tester, 'Paddle 0', 'Compare'), isTrue);

    final first = tester.getTopLeft(find.text('Paddle 0'));
    final second = tester.getTopLeft(find.text('Paddle 1'));
    // The second row is past the bottom of the screen.
    final third = tester.getTopLeft(find.text('Paddle 2', skipOffstage: false));
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
    expect(third.dx, first.dx);
    expect(third.dy, greaterThan(first.dy));
  });

  testWidgets('shows an error with a retry that reloads', (tester) async {
    final repository = FakePaddleRepository(catalogPaddles(5))
      ..error = const PaddleRepositoryException('down');
    await pumpCatalogPage(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Loading…'), findsNothing);

    repository.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Paddle 0'), findsOneWidget);
  });

  testWidgets('search waits for a pause in typing, then goes to the URL', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(5));
    final router = await pumpCatalogPage(tester, repository);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'paddle 3');
    await tester.pump(const Duration(milliseconds: 299));

    expect(_url(router).queryParameters, isEmpty);
    expect(repository.queries, hasLength(1));

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();

    expect(_url(router).queryParameters, {'q': 'paddle 3'});
    expect(repository.queries.last.search, 'paddle 3');
    expect(find.text('Paddle 3'), findsOneWidget);
    expect(find.text('Paddle 0'), findsNothing);
    expect(find.text('1 paddle'), findsOneWidget);
  });

  testWidgets('announces the count once, a second after new results land', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(5));
    await pumpCatalogPage(tester, repository);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeAnnouncements(), [
      isAccessibilityAnnouncement('5 paddles'),
    ]);

    repository.gate = Completer<void>();
    await tester.enterText(find.byType(TextField), 'paddle 3');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    // A slow load says nothing.
    await tester.pump(const Duration(seconds: 2));

    expect(repository.queries.last.search, 'paddle 3');
    expect(find.text('Loading…'), findsOneWidget);
    expect(tester.takeAnnouncements(), isEmpty);

    repository.gate!.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 999));

    expect(find.text('1 paddle'), findsOneWidget);
    expect(tester.takeAnnouncements(), isEmpty);

    await tester.pump(const Duration(milliseconds: 1));

    expect(tester.takeAnnouncements(), [
      isAccessibilityAnnouncement('1 paddle'),
    ]);
  });

  testWidgets('empty state clears the filters and the search field', (
    tester,
  ) async {
    final router = await pumpCatalogPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nothing like this');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('No paddles found'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();

    expect(find.text('No paddles found'), findsNothing);
    expect(find.text('Paddle 0'), findsOneWidget);
    expect(_searchText(tester), isEmpty);
    expect(_url(router).toString(), '/');
  });

  testWidgets('a deep link restores the search, the chips and the grid', (
    tester,
  ) async {
    await pumpCatalogPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
      location: '/?q=paddle%203&shape=hybrid',
    );
    await tester.pumpAndSettle();

    expect(_searchText(tester), 'paddle 3');
    expect(find.widgetWithText(InputChip, 'Hybrid'), findsOneWidget);
    expect(find.text('Paddle 3'), findsOneWidget);
    expect(find.text('Paddle 1'), findsNothing);
  });

  testWidgets('a deep link sorts the whole catalog, not just the first page', (
    tester,
  ) async {
    await pumpCatalogPage(
      tester,
      FakePaddleRepository(catalogPaddles(20)),
      location: '/?sort=price-desc',
    );
    await tester.pumpAndSettle();

    expect(find.text('Highest price'), findsOneWidget);
    final first = tester.getTopLeft(find.text('Paddle 19'));
    final second = tester.getTopLeft(find.text('Paddle 18'));
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
  });

  testWidgets('falls back when the image or price is missing', (tester) async {
    await pumpCatalogPage(
      tester,
      FakePaddleRepository([
        const Paddle(id: 'x', brand: 'Brand', name: 'Mystery', inStock: false),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('NO IMAGE'), findsOneWidget);
    expect(find.text('Price unavailable'), findsOneWidget);
    expect(find.text('SOLD OUT'), findsOneWidget);
  });

  testWidgets('a screen reader reads each card as one button', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpCatalogPage(tester, FakePaddleRepository(catalogPaddles(1)));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byType(PaddleCard)),
      isSemantics(
        label: 'No image\nBrand\nPaddle 0\n\$100.00\nView details',
        isButton: true,
        hasTapAction: true,
        customActions: [const CustomSemanticsAction(label: 'Add to compare')],
      ),
    );
    semantics.dispose();
  });

  testWidgets('the filter sheet filters by shape and shows removable chips', (
    tester,
  ) async {
    final router = await pumpCatalogPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Hybrid'));
    await tester.pumpAndSettle();

    // The URL changed, but the page and its sheet stay.
    expect(_url(router).queryParametersAll, {
      'shape': ['hybrid'],
    });
    expect(find.byType(FilterSheet), findsOneWidget);
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Hybrid')),
      isA<FilterChip>().having((chip) => chip.selected, 'selected', isTrue),
    );

    await tester.tap(find.text('Show 2 paddles'));
    await tester.pumpAndSettle();

    expect(find.text('Paddle 1'), findsOneWidget);
    expect(find.text('Paddle 0'), findsNothing);
    expect(find.widgetWithText(InputChip, 'Hybrid'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Hybrid filter'));
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsNothing);
    expect(find.text('Paddle 0'), findsOneWidget);
    expect(_url(router).toString(), '/');
  });

  testWidgets('the sort sheet reorders the grid', (tester) async {
    final router = await pumpCatalogPage(
      tester,
      FakePaddleRepository(catalogPaddles(5)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: High to Low'));
    await tester.pumpAndSettle();

    expect(_url(router).queryParameters, {'sort': 'price-desc'});
    expect(find.text('Highest price'), findsOneWidget);
    final first = tester.getTopLeft(find.text('Paddle 4'));
    final second = tester.getTopLeft(find.text('Paddle 3'));
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
    // The second row is past the bottom of the screen.
    final below = find.text('Paddle 2', skipOffstage: false);
    expect(tester.getTopLeft(below).dy, greaterThan(first.dy));
  });

  testWidgets('a filter change replaces the history entry, not adds one', (
    tester,
  ) async {
    final reports = recordUrlReports(tester);
    await pumpCatalogPage(tester, FakePaddleRepository(catalogPaddles(5)));
    await tester.pumpAndSettle();
    reports.clear();

    await tester.tap(find.text('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: High to Low'));
    await tester.pumpAndSettle();

    expect(reports, [
      allOf(
        containsPair('uri', '/?sort=price-desc'),
        containsPair('replace', true),
      ),
    ]);
  });

  testWidgets('while reloading, the old grid is dimmed under a progress bar', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(5));
    await pumpCatalogPage(tester, repository);
    await tester.pumpAndSettle();

    expect(_updating, findsNothing);
    expect(_gridOpacity(tester), 1);

    repository.gate = Completer<void>();
    await tester.tap(find.text('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: High to Low'));
    // The progress bar never settles, so the sheet's exit is pumped by hand.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(_updating, findsOneWidget);
    expect(find.text('Loading…'), findsOneWidget);
    expect(_gridOpacity(tester), lessThan(1));
    expect(find.text('Paddle 0'), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(_updating, findsNothing);
    expect(_gridOpacity(tester), 1);
    expect(find.text('5 paddles'), findsOneWidget);
  });

  testWidgets('loads the next page when the end of the grid scrolls in', (
    tester,
  ) async {
    final repository = FakePaddleRepository(catalogPaddles(20));
    await pumpCatalogPage(tester, repository);
    await tester.pumpAndSettle();

    expect(repository.offsets, [0]);
    expect(find.text('12+ paddles'), findsOneWidget);

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -4000),
      4000,
    );
    await tester.pumpAndSettle();

    expect(repository.offsets, [0, 12]);
    expect(find.text('20 paddles'), findsOneWidget);
  });

  testWidgets('focusing the search keeps the scroll position', (tester) async {
    await pumpCatalogPage(tester, FakePaddleRepository(catalogPaddles(12)));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    final position = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position;
    final scrolled = position.pixels;
    expect(scrolled, greaterThan(0));

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(position.pixels, scrolled);
  });

  group('compare tray', () {
    testWidgets('is hidden when nothing is being compared', (tester) async {
      await pumpCatalogPage(tester, FakePaddleRepository(catalogPaddles(3)));
      await tester.pumpAndSettle();

      expect(find.byType(CompareTray), findsNothing);
    });

    testWidgets('a card adds its paddle to the tray, in place', (tester) async {
      final reports = recordUrlReports(tester);
      final repository = FakePaddleRepository(catalogPaddles(3));
      final router = await pumpCatalogPage(tester, repository);
      await tester.pumpAndSettle();
      reports.clear();

      await tester.tap(_cardButton('Paddle 0', 'Compare'));
      await tester.pumpAndSettle();

      expect(_url(router).toString(), '/?compare=p0');
      expect(reports, [
        allOf(
          containsPair('uri', '/?compare=p0'),
          containsPair('replace', true),
        ),
      ]);
      expect(find.byType(CompareView), findsNothing);
      expect(_inTray(find.text('Paddle 0')), findsOneWidget);
      expect(_inTray(find.text('Add a paddle')), findsOneWidget);
      expect(_cardButtonEnabled(tester, 'Paddle 0', 'Added'), isFalse);
      expect(_cardButtonEnabled(tester, 'Paddle 1', 'Compare'), isTrue);
      expect(repository.ids, ['p0']);
    });

    testWidgets('loads the paddle and leaves room for another', (tester) async {
      final repository = FakePaddleRepository(catalogPaddles(3));
      await pumpCatalogPage(tester, repository, location: '/?compare=p0');
      await tester.pumpAndSettle();

      expect(_inTray(find.text('Paddle 0')), findsOneWidget);
      expect(_inTray(find.text('Add a paddle')), findsOneWidget);
      expect(
        tester.getTopLeft(_inTray(find.text('Paddle 0'))).dx,
        lessThan(tester.getTopLeft(_inTray(find.text('Add a paddle'))).dx),
      );
      expect(repository.ids, ['p0']);
      // The paddle already in the comparison says so; the others can join.
      expect(_cardButtonEnabled(tester, 'Paddle 0', 'Added'), isFalse);
      expect(_cardButtonEnabled(tester, 'Paddle 1', 'Compare'), isTrue);
      await _scrollTo(tester, 'Paddle 2');
      expect(_cardButtonEnabled(tester, 'Paddle 2', 'Compare'), isTrue);
    });

    testWidgets('a card completes the comparison and opens it', (tester) async {
      final repository = FakePaddleRepository(catalogPaddles(3));
      final router = await pumpCatalogPage(
        tester,
        repository,
        location: '/?compare=p0',
      );
      await tester.pumpAndSettle();

      await _scrollTo(tester, 'Paddle 1');
      await tester.tap(_cardButton('Paddle 1', 'Compare'));
      await tester.pumpAndSettle();

      expect(_url(router).toString(), '/compare?compare=p0&compare=p1');
      expect(_inSheet(find.text('Paddle 0')), findsOneWidget);
      expect(_inSheet(find.text('Paddle 1')), findsOneWidget);
      // The tray and the sheet share each paddle's request.
      expect(repository.ids, ['p0', 'p1']);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(CompareView), findsNothing);
      expect(_url(router).toString(), '/?compare=p0&compare=p1');
      expect(_inTray(find.text('Paddle 1')), findsOneWidget);
      expect(_inTray(find.text('Add a paddle')), findsNothing);
      // Full: no other card can join.
      expect(_cardButtonEnabled(tester, 'Paddle 0', 'Added'), isFalse);
      expect(_cardButtonEnabled(tester, 'Paddle 1', 'Added'), isFalse);
      await _scrollTo(tester, 'Paddle 2');
      expect(_cardButtonEnabled(tester, 'Paddle 2', 'Compare'), isFalse);
      expect(repository.ids, ['p0', 'p1']);
    });

    testWidgets('a disabled compare button does nothing', (tester) async {
      final router = await pumpCatalogPage(
        tester,
        FakePaddleRepository(catalogPaddles(3)),
        location: '/?compare=p0&compare=p1',
      );
      await tester.pumpAndSettle();

      await _scrollTo(tester, 'Paddle 0');
      await tester.tap(_cardButton('Paddle 0', 'Added'));
      await tester.pumpAndSettle();
      await _scrollTo(tester, 'Paddle 2');
      await tester.tap(_cardButton('Paddle 2', 'Compare'));
      await tester.pumpAndSettle();

      // Neither opens the details of its paddle.
      expect(_url(router).toString(), '/?compare=p0&compare=p1');
    });

    testWidgets('tapping the tray opens the comparison', (tester) async {
      final router = await pumpCatalogPage(
        tester,
        FakePaddleRepository(catalogPaddles(3)),
        location: '/?shape=standard&compare=p0',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.expand_less));
      await tester.pumpAndSettle();

      expect(_url(router).toString(), '/compare?shape=standard&compare=p0');
      expect(tester.widget<CompareView>(find.byType(CompareView)).ids, ['p0']);
    });

    testWidgets('removing the last paddle hides the tray, in place', (
      tester,
    ) async {
      final reports = recordUrlReports(tester);
      await pumpCatalogPage(
        tester,
        FakePaddleRepository(catalogPaddles(3)),
        location: '/?compare=p0',
      );
      await tester.pumpAndSettle();
      reports.clear();

      await tester.tap(find.byTooltip('Remove Paddle 0'));
      await tester.pumpAndSettle();

      expect(reports, [
        allOf(containsPair('uri', '/'), containsPair('replace', true)),
      ]);
      expect(find.byType(CompareTray), findsNothing);
      expect(_cardButtonEnabled(tester, 'Paddle 0', 'Compare'), isTrue);
    });

    testWidgets('a filter change keeps the comparison', (tester) async {
      final router = await pumpCatalogPage(
        tester,
        FakePaddleRepository(catalogPaddles(3)),
        location: '/?compare=p0',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Price: High to Low'));
      await tester.pumpAndSettle();

      expect(_url(router).queryParametersAll, {
        'sort': ['price-desc'],
        'compare': ['p0'],
      });
      expect(_inTray(find.text('Paddle 0')), findsOneWidget);
    });

    testWidgets('a screen reader hears which cards are in the comparison', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpCatalogPage(
        tester,
        FakePaddleRepository(catalogPaddles(2)),
        location: '/?compare=p0',
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.widgetWithText(PaddleCard, 'Paddle 0')),
        isSemantics(
          label: 'No image\nBrand\nPaddle 0\n\$100.00\nView details',
          value: 'Added to compare',
          isButton: true,
          hasTapAction: true,
          customActions: const <CustomSemanticsAction>[],
        ),
      );
      expect(
        tester.getSemantics(find.widgetWithText(PaddleCard, 'Paddle 1')),
        isSemantics(
          label: 'No image\nBrand\nPaddle 1\n\$101.00\nView details',
          isButton: true,
          hasTapAction: true,
          customActions: [const CustomSemanticsAction(label: 'Add to compare')],
        ),
      );
      semantics.dispose();
    });
  });
}
