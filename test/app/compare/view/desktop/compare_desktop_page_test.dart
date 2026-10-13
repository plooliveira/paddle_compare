import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/compare/view/compare_view.dart';
import 'package:paddle_compare/app/compare/view/desktop/compare_desktop_page.dart';
import 'package:paddle_compare/app/compare/view/mobile/compare_mobile_page.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

import '../../../../helpers/fake_paddle_repository.dart';
import '../../../../helpers/finders.dart';
import '../../../../helpers/pump_app.dart';

const _summit = Paddle(
  id: 'summit',
  brand: 'Apex Court',
  name: 'Summit Pro 16',
  priceUsd: 249.99,
  shape: PaddleShape.elongated,
  weightOz: 8,
  ratings: PaddleRatings(power: 7),
);

const _volt = Paddle(
  id: 'volt',
  brand: 'Brand',
  name: 'Volt',
  shape: PaddleShape.hybrid,
  ratings: PaddleRatings(),
);

const _rally = Paddle(
  id: 'rally',
  brand: 'Brand',
  name: 'Rally',
  shape: PaddleShape.widebody,
  ratings: PaddleRatings(),
);

/// Opens `/compare` with [query], over the catalog.
Future<GoRouter> _pumpPage(
  WidgetTester tester,
  FakePaddleRepository repository,
  Map<String, Object> query, {
  Size size = desktop,
}) async {
  final router = await pumpApp(
    tester,
    repository,
    location: Uri(path: '/compare', queryParameters: query).toString(),
    size: size,
    devicePixelRatio: 1,
  );
  await tester.pumpAndSettle();
  return router;
}

Finder _text(String text) => inComparison(find.text(text));

void main() {
  testWidgets('is a page of its own, with three paddles side by side', (
    tester,
  ) async {
    final repository = FakePaddleRepository([_summit, _volt, _rally]);
    await _pumpPage(tester, repository, {
      'compare': ['summit', 'volt', 'rally'],
    });

    expect(find.byType(CompareDesktopPage), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    expect(_text('Select paddle'), findsNothing);
    expect(repository.ids, ['summit', 'volt', 'rally']);

    final names = ['Summit Pro 16', 'Volt', 'Rally'];
    for (final (index, name) in names.indexed.skip(1)) {
      expect(
        tester.getTopLeft(_text(names[index - 1])).dx,
        lessThan(tester.getTopLeft(_text(name)).dx),
      );
    }
    // Each value sits in its paddle's column.
    for (final (name, shape) in [
      ('Summit Pro 16', 'Elongated'),
      ('Volt', 'Hybrid'),
      ('Rally', 'Widebody'),
    ]) {
      expect(
        tester.getTopLeft(_text(shape)).dx,
        tester.getTopLeft(_text(name)).dx,
        reason: shape,
      );
    }
  });

  testWidgets('puts the labels in a column on the left of the values', (
    tester,
  ) async {
    await _pumpPage(tester, FakePaddleRepository([_summit]), {
      'compare': 'summit',
    });

    final label = tester.getRect(_text('WEIGHT'));
    final value = tester.getRect(_text('8.0 oz · 227 g'));
    expect(label.right, lessThan(value.left));
    expect(label.center.dy, closeTo(value.center.dy, 1));
  });

  testWidgets('an empty column goes back to the catalog to pick a paddle', (
    tester,
  ) async {
    final router = await _pumpPage(tester, FakePaddleRepository([_summit]), {
      'shape': 'hybrid',
      'compare': 'summit',
    });

    expect(_text('Select paddle'), findsNWidgets(2));

    await tester.tap(_text('Select paddle').first);
    await tester.pumpAndSettle();

    expect(find.byType(CompareView), findsNothing);
    expect(currentUrl(router), '/?shape=hybrid&compare=summit');
  });

  testWidgets('the back button goes back to the catalog, keeping its query', (
    tester,
  ) async {
    final router = await _pumpPage(tester, FakePaddleRepository([_summit]), {
      'q': 'apex',
      'compare': 'summit',
    });

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(CompareView), findsNothing);
    expect(currentUrl(router), '/?q=apex&compare=summit');
  });

  testWidgets('a column that fails retries on its own; an unknown id says so', (
    tester,
  ) async {
    final repository = FakePaddleRepository([_summit])
      ..error = const PaddleRepositoryException('down');
    await _pumpPage(tester, repository, {
      'compare': ['summit', 'nope'],
    });

    expect(_text("Couldn't load this paddle"), findsNWidgets(2));

    repository.error = null;
    await tester.tap(_text('Try again').first);
    await tester.pumpAndSettle();

    expect(_text('Summit Pro 16'), findsOneWidget);
    expect(_text("Couldn't load this paddle"), findsOneWidget);

    await tester.tap(_text('Try again'));
    await tester.pumpAndSettle();

    expect(_text('Paddle not found'), findsOneWidget);
    expect(repository.ids, ['summit', 'nope', 'summit', 'nope']);
  });

  testWidgets('fits at the narrowest desktop width, in a short window', (
    tester,
  ) async {
    await _pumpPage(tester, FakePaddleRepository([_summit, _volt, _rally]), {
      'compare': ['summit', 'volt', 'rally'],
    }, size: const Size(840, 560));

    // The images leave room for the first specs.
    expect(tester.getBottomLeft(_text('Elongated')).dy, lessThan(560));
  });

  testWidgets('a resize swaps the sheet and the page, at the same URL', (
    tester,
  ) async {
    final repository = FakePaddleRepository([_summit, _volt, _rally]);
    final router = await _pumpPage(tester, repository, {
      'compare': ['summit', 'volt', 'rally'],
    }, size: phone);
    const url = '/compare?compare=summit&compare=volt&compare=rally';

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(CompareMobilePage), findsOneWidget);

    resize(tester, desktop);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(CompareDesktopPage), findsOneWidget);
    expect(_text('Rally'), findsOneWidget);
    expect(currentUrl(router), url);

    resize(tester, phone);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(CompareMobilePage), findsOneWidget);
    expect(currentUrl(router), url);
    // The paddles were loaded once, whatever showed them.
    expect(repository.ids, ['summit', 'volt', 'rally']);
  });
}
