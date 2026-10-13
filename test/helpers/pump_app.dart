import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/app/router.dart';
import 'package:paddle_compare/core/theme/app_theme.dart';
import 'package:paddle_compare/data/repositories/paddle/paddle_repository_provider.dart';

import 'fake_paddle_repository.dart';

const phone = Size(375, 812);
const desktop = Size(1280, 800);

/// Pumps the app at [location] in a window of [size] logical pixels, set up
/// like main.dart. The default is a phone.
Future<GoRouter> pumpApp(
  WidgetTester tester,
  FakePaddleRepository repository, {
  String location = '/',
  Size size = phone,
  double devicePixelRatio = 3,
}) async {
  // As in main.dart, so the URL shows pushed pages too.
  GoRouter.optionURLReflectsImperativeAPIs = true;
  addTearDown(() => GoRouter.optionURLReflectsImperativeAPIs = false);
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

/// Resizes the window, in logical pixels, keeping its pixel ratio.
void resize(WidgetTester tester, Size size) =>
    tester.view.physicalSize = size * tester.view.devicePixelRatio;

/// The URL the browser shows, pushed pages included.
String currentUrl(GoRouter router) =>
    router.routeInformationProvider.value.uri.toString();
