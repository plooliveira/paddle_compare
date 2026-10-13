import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/app/compare/view/widgets/compare_tray.dart';
import 'package:paddle_compare/app/paddle_detail/view/desktop/paddle_detail_desktop_page.dart';
import 'package:paddle_compare/app/paddle_detail/view/desktop/widgets/paddle_detail_desktop_skeleton.dart';
import 'package:paddle_compare/app/paddle_detail/view/mobile/paddle_detail_mobile_page.dart';
import 'package:paddle_compare/app/paddle_detail/view/paddle_detail_view.dart';
import 'package:paddle_compare/app/paddle_detail/view/widgets/paddle_detail_header.dart';
import 'package:paddle_compare/app/paddle_detail/view/widgets/paddle_detail_image.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../../../../helpers/catalog_pages.dart';
import '../../../../helpers/fake_paddle_repository.dart';
import '../../../../helpers/url_reports.dart';

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

const _other = Paddle(id: 'other', brand: 'Brand', name: 'Other Paddle');

const _desktop = Size(1280, 800);

Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/paddles/summit',
  Size size = _desktop,
}) => pumpCatalogPage(
  tester,
  repository,
  location: location,
  size: size,
  devicePixelRatio: 1,
);

Uri _url(GoRouter router) => router.routerDelegate.currentConfiguration.uri;

/// What the browser shows, pushed pages included.
String _browserUrl(GoRouter router) =>
    router.routeInformationProvider.value.uri.toString();

/// As in main.dart, so the URL shows the pushed page.
void _reflectImperativeUrls() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  addTearDown(() => GoRouter.optionURLReflectsImperativeAPIs = false);
}

Finder _button(String label) => find.ancestor(
  of: find.text(label),
  matching: find.bySubtype<ButtonStyleButton>(),
);

final _compareButton = _button('Add to compare');

bool _enabled(WidgetTester tester, Finder button) =>
    tester.widget<ButtonStyleButton>(button).enabled;

Finder _inTray(Finder finder) =>
    find.descendant(of: find.byType(CompareTray), matching: finder);

void main() {
  testWidgets('the image sits beside the details, specs all open', (
    tester,
  ) async {
    await _pumpPage(tester, FakePaddleRepository([_full]));
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailDesktopPage), findsOneWidget);
    expect(find.text('Paddles'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.byType(CompareTray), findsNothing);

    final image = tester.getRect(find.byType(PaddleDetailImage));
    final header = tester.getRect(find.byType(PaddleDetailHeader));
    expect(image.right, lessThan(header.left));
    expect(image.top, header.top);
    // The illustrations' proportions.
    expect(image.width / image.height, closeTo(3 / 4, 0.01));

    expect(find.text('FULL SPECIFICATIONS'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNothing);
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

  testWidgets('only the details scroll', (tester) async {
    await _pumpPage(tester, FakePaddleRepository([_full]));
    await tester.pumpAndSettle();
    final image = tester.getRect(find.byType(PaddleDetailImage));
    final header = tester.getRect(find.byType(PaddleDetailHeader));

    await tester.drag(
      find.text('Key specs'.toUpperCase()),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byType(PaddleDetailImage)), image);
    expect(
      tester.getRect(find.byType(PaddleDetailHeader)).top,
      lessThan(header.top),
    );
  });

  testWidgets('key specs make one row, or two in a narrow window', (
    tester,
  ) async {
    double top(String label) => tester.getTopLeft(find.text(label)).dy;

    await _pumpPage(tester, FakePaddleRepository([_full]));
    await tester.pumpAndSettle();

    expect(top('CORE'), top('SHAPE'));
    expect(top('FACE'), top('SHAPE'));

    tester.view.physicalSize = const Size(840, 800);
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailDesktopPage), findsOneWidget);
    expect(top('WEIGHT'), top('SHAPE'));
    expect(top('CORE'), greaterThan(top('SHAPE')));
    expect(top('FACE'), top('CORE'));
  });

  testWidgets('add to compare stays on the page and fills the tray', (
    tester,
  ) async {
    final reports = recordUrlReports(tester);
    final repository = FakePaddleRepository([_full, _other]);
    final router = await _pumpPage(
      tester,
      repository,
      location: '/paddles/summit?sort=power&compare=other',
    );
    await tester.pumpAndSettle();
    final page = tester.state(find.byType(PaddleDetailView));
    expect(find.text('1 of 3 in compare'), findsOneWidget);
    reports.clear();

    await tester.tap(_compareButton);
    await tester.pumpAndSettle();

    expect(
      _url(router).toString(),
      '/paddles/summit?sort=power&compare=other&compare=summit',
    );
    expect(reports, [containsPair('replace', true)]);
    expect(tester.state(find.byType(PaddleDetailView)), same(page));
    expect(find.byType(CompareView), findsNothing);
    expect(_inTray(find.text('Other Paddle')), findsOneWidget);
    expect(_inTray(find.text('Summit Pro 16')), findsOneWidget);
    expect(_inTray(find.text('Add a paddle')), findsOneWidget);
    expect(_enabled(tester, _button('Added to compare')), isFalse);
    // The page loaded its paddle once; the tray asked for each of its own.
    expect(repository.ids.where((id) => id == 'summit'), hasLength(2));
  });

  testWidgets('from the catalog, the page stays and Back finds it updated', (
    tester,
  ) async {
    _reflectImperativeUrls();
    final repository = FakePaddleRepository([_full]);
    final router = await _pumpPage(
      tester,
      repository,
      location: '/?sort=price-asc',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('View details'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();

    expect(_browserUrl(router), '/paddles/summit?sort=price-asc');
    final page = tester.state(find.byType(PaddleDetailView));
    final queries = repository.queries.length;

    await tester.tap(_compareButton);
    await tester.pumpAndSettle();

    expect(
      _browserUrl(router),
      '/paddles/summit?sort=price-asc&compare=summit',
    );
    expect(tester.state(find.byType(PaddleDetailView)), same(page));
    expect(_inTray(find.text('Summit Pro 16')), findsOneWidget);
    // The detail's request and the tray's.
    expect(repository.ids, ['summit', 'summit']);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(_browserUrl(router), '/?sort=price-asc&compare=summit');
    expect(find.byType(PaddleDetailView), findsNothing);
    expect(_inTray(find.text('Summit Pro 16')), findsOneWidget);
    expect(find.text('Sort: Price: Low to High'), findsOneWidget);
    expect(repository.queries, hasLength(queries));
  });

  testWidgets('the third paddle opens the comparison', (tester) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository([_full]),
      location: '/paddles/summit?compare=a&compare=b',
    );
    await tester.pumpAndSettle();

    expect(find.text('2 of 3 in compare'), findsOneWidget);
    await tester.tap(_compareButton);
    await tester.pumpAndSettle();

    expect(
      _url(router).toString(),
      '/compare?compare=a&compare=b&compare=summit',
    );
    expect(find.byType(PaddleDetailView), findsNothing);
    expect(tester.widget<CompareView>(find.byType(CompareView)).ids, [
      'a',
      'b',
      'summit',
    ]);
  });

  testWidgets('a paddle already compared points to the tray', (tester) async {
    await _pumpPage(
      tester,
      FakePaddleRepository([_full]),
      location: '/paddles/summit?compare=summit',
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to compare'), findsNothing);
    expect(_enabled(tester, _button('Added to compare')), isFalse);
    expect(
      find.descendant(
        of: _button('Added to compare'),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    expect(find.text('Remove it from the tray below'), findsOneWidget);
  });

  testWidgets('a full comparison says how to make room', (tester) async {
    await _pumpPage(
      tester,
      FakePaddleRepository([_full]),
      location: '/paddles/summit?compare=a&compare=b&compare=c',
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to compare'), findsNothing);
    expect(_enabled(tester, _button('Compare is full')), isFalse);
    expect(
      find.text('Remove a paddle from the tray to add this one'),
      findsOneWidget,
    );
  });

  testWidgets("the tray's remove button keeps the page", (tester) async {
    final reports = recordUrlReports(tester);
    final router = await _pumpPage(
      tester,
      FakePaddleRepository([_full, _other]),
      location: '/paddles/summit?compare=other&compare=summit',
    );
    await tester.pumpAndSettle();
    final page = tester.state(find.byType(PaddleDetailView));
    reports.clear();

    await tester.tap(find.byTooltip('Remove Summit Pro 16'));
    await tester.pumpAndSettle();

    expect(_url(router).toString(), '/paddles/summit?compare=other');
    expect(reports, [containsPair('replace', true)]);
    expect(tester.state(find.byType(PaddleDetailView)), same(page));
    expect(_inTray(find.text('Summit Pro 16')), findsNothing);
    expect(_enabled(tester, _compareButton), isTrue);

    await tester.tap(find.byTooltip('Remove Other Paddle'));
    await tester.pumpAndSettle();

    expect(_url(router).toString(), '/paddles/summit');
    expect(find.byType(CompareTray), findsNothing);
    expect(find.text('Summit Pro 16'), findsOneWidget);
  });

  testWidgets('tapping the tray opens the comparison', (tester) async {
    final router = await _pumpPage(
      tester,
      FakePaddleRepository([_full, _other]),
      location: '/paddles/summit?compare=other',
    );
    await tester.pumpAndSettle();

    await tester.tap(_inTray(find.text('Add a paddle')).first);
    await tester.pumpAndSettle();

    expect(_url(router).toString(), '/compare?compare=other');
    expect(find.byType(CompareView), findsOneWidget);
  });

  testWidgets('shows a skeleton and a disabled button while loading', (
    tester,
  ) async {
    final repository = FakePaddleRepository([_full, _other])
      ..gate = Completer<void>();
    await _pumpPage(
      tester,
      repository,
      location: '/paddles/summit?compare=other',
    );

    expect(find.byType(PaddleDetailDesktopSkeleton), findsOneWidget);
    expect(_enabled(tester, _compareButton), isFalse);
    expect(find.byType(CompareTray), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailDesktopSkeleton), findsNothing);
    expect(find.byType(PaddleDetailHeader), findsOneWidget);
    expect(_enabled(tester, _compareButton), isTrue);
  });

  testWidgets('shows an error with a retry, and keeps the tray', (
    tester,
  ) async {
    final repository = FakePaddleRepository([_full, _other])
      ..error = const PaddleRepositoryException('down');
    await _pumpPage(
      tester,
      repository,
      location: '/paddles/summit?compare=other',
    );
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Add to compare'), findsNothing);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.byType(CompareTray), findsOneWidget);

    repository.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
    expect(find.byType(PaddleDetailHeader), findsOneWidget);
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

  testWidgets('fits at the narrowest desktop width, in a short window', (
    tester,
  ) async {
    // Any overflow fails the test.
    await _pumpPage(
      tester,
      FakePaddleRepository([_full]),
      location: '/paddles/summit?compare=summit&compare=b&compare=c',
      size: const Size(840, 600),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailDesktopPage), findsOneWidget);
    expect(find.byType(CompareTray), findsOneWidget);
    final image = tester.getRect(find.byType(PaddleDetailImage));
    expect(
      image.bottom,
      lessThan(tester.getTopLeft(find.byType(CompareTray)).dy),
    );
    expect(image.width / image.height, closeTo(3 / 4, 0.01));
  });

  testWidgets('a resize to a phone swaps to the mobile layout', (tester) async {
    final repository = FakePaddleRepository([_full, _other]);
    final router = await _pumpPage(
      tester,
      repository,
      location: '/paddles/summit?compare=other',
    );
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpAndSettle();

    expect(find.byType(PaddleDetailDesktopPage), findsNothing);
    expect(find.byType(PaddleDetailMobilePage), findsOneWidget);
    expect(find.text('Summit Pro 16'), findsOneWidget);
    // The mobile page has no tray; its bar adds instead.
    expect(find.byType(CompareTray), findsNothing);
    expect(_enabled(tester, _compareButton), isTrue);
    expect(_url(router).toString(), '/paddles/summit?compare=other');
    expect(repository.ids.where((id) => id == 'summit'), hasLength(1));
  });
}
