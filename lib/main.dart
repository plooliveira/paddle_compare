import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';

void main() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  LicenseRegistry.addLicense(_fontLicenses);
  runApp(const ProviderScope(child: PaddleCompareApp()));
}

Stream<LicenseEntry> _fontLicenses() async* {
  for (final (font, file) in [
    ('Inter', 'Inter-OFL.txt'),
    ('Playfair Display', 'PlayfairDisplay-OFL.txt'),
  ]) {
    final text = await rootBundle.loadString('assets/fonts/$file');
    yield LicenseEntryWithLineBreaks([font], text);
  }
}
