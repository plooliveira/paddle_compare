import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/router.dart';
import 'package:paddle_compare/core/theme/app_theme.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import 'fake_paddle_repository.dart';

/// Even indexes are standard, odd ones hybrid. Prices go up with the index.
List<Paddle> catalogPaddles(int count) => [
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

/// Pumps the app at [location] in a window of [size] logical pixels. The
/// default is a phone.
Future<GoRouter> pumpCatalogPage(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/',
  Size size = const Size(375, 812),
  double devicePixelRatio = 3,
}) async {
  tester.view.physicalSize = size * devicePixelRatio;
  tester.view.devicePixelRatio = devicePixelRatio;
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
