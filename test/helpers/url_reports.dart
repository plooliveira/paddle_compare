import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records the URLs reported to the browser. `replace: true` means no new
/// history entry.
List<Map<Object?, Object?>> recordUrlReports(WidgetTester tester) {
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
  return reports;
}
