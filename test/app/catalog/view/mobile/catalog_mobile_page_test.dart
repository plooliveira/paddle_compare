import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/catalog/view/mobile/widgets/filter_sheet.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card.dart';
import 'package:paddle_compare/app/catalog/view/widgets/paddle_card_skeleton.dart';
import 'package:paddle_compare/app/router.dart';
import 'package:paddle_compare/core/theme/app_theme.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import '../../../../helpers/fake_paddle_repository.dart';

/// Even indexes are standard, odd ones hybrid. Prices go up with the index.
List<Paddle> _paddles(int count) => [
  for (var i = 0; i < count; i++)
    Paddle(
      id: 'p$i',
      brand: 'Brand',
      name: 'Paddle $i',
      priceUsd: 100.0 + i,
      inStock: true,
      shape: i.isEven ? PaddleShape.standard : PaddleShape.hybrid,
    ),
];

Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/',
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

String _searchText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

double _gridOpacity(WidgetTester tester) =>
    tester.widget<SliverOpacity>(find.byType(SliverOpacity)).opacity;

final _updating = find.bySemanticsLabel('Updating results');

void main() {
  testWidgets('shows skeletons while loading, then two cards per row', (
    tester,
  ) async {
    final repository = FakePaddleRepository(_paddles(5))
      ..gate = Completer<void>();
    await _pumpPage(tester, repository);

    expect(find.byType(PaddleCardSkeleton), findsWidgets);
    expect(find.text('Loading…'), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(PaddleCardSkeleton), findsNothing);
    expect(find.text('5 paddles'), findsOneWidget);
    expect(find.text('Paddle 0'), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PaddleCard).first,
        matching: find.text('View details'),
      ),
      findsOneWidget,
    );

    final first = tester.getTopLeft(find.text('Paddle 0'));
    final second = tester.getTopLeft(find.text('Paddle 1'));
    final third = tester.getTopLeft(find.text('Paddle 2'));
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
    expect(third.dx, first.dx);
    expect(third.dy, greaterThan(first.dy));
  });

  testWidgets('shows an error with a retry that reloads', (tester) async {
    final repository = FakePaddleRepository(_paddles(5))
      ..error = const PaddleRepositoryException('down');
    await _pumpPage(tester, repository);
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
    final repository = FakePaddleRepository(_paddles(5));
    final router = await _pumpPage(tester, repository);
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

  testWidgets('empty state clears the filters and the search field', (
    tester,
  ) async {
    final router = await _pumpPage(tester, FakePaddleRepository(_paddles(5)));
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
    await _pumpPage(
      tester,
      FakePaddleRepository(_paddles(5)),
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
    await _pumpPage(
      tester,
      FakePaddleRepository(_paddles(20)),
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
    await _pumpPage(
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

  testWidgets('the filter sheet filters by shape and shows removable chips', (
    tester,
  ) async {
    final router = await _pumpPage(tester, FakePaddleRepository(_paddles(5)));
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
    final router = await _pumpPage(tester, FakePaddleRepository(_paddles(5)));
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
    expect(tester.getTopLeft(find.text('Paddle 2')).dy, greaterThan(first.dy));
  });

  testWidgets('a filter change replaces the history entry, not adds one', (
    tester,
  ) async {
    final reports = <Map<Object?, Object?>>[];
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.navigation, (call) async {
      if (call.method == 'routeInformationUpdated') {
        reports.add(call.arguments as Map<Object?, Object?>);
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.navigation, null),
    );
    await _pumpPage(tester, FakePaddleRepository(_paddles(5)));
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
    final repository = FakePaddleRepository(_paddles(5));
    await _pumpPage(tester, repository);
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
    final repository = FakePaddleRepository(_paddles(20));
    await _pumpPage(tester, repository);
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
}
