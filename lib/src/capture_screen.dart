import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'config.dart';
import 'globals.dart';

/// Called by integration test to capture images.
Future screenshotDriver(final driver, Config config, String name,
    {Duration timeout = const Duration(seconds: 30),
    bool silent = false,
    bool waitUntilNoTransientCallbacks = true}) async {
  if (config.isScreenShotsAvailable) {
    // todo: auto-naming scheme
    if (waitUntilNoTransientCallbacks) {
      await driver.waitUntilNoTransientCallbacks(timeout: timeout);
    }

    final pixels = await driver.screenshot();
    final testDir = '${config.stagingDir}/$kTestScreenshotsDir';
    final file = await File('$testDir/$name.$kImageExtension').create(recursive: true);
    await file.writeAsBytes(pixels);
    if (!silent) print('Screenshot $name created');
  } else {
    if (!silent) print('Warning: screenshot $name not created');
  }
}

Future screenshot(IntegrationTestWidgetsFlutterBinding binding, WidgetTester tester, String name,
    {bool silent = false}) async {
  // This is required prior to taking the screenshot (Android only).
  await binding.convertFlutterSurfaceToImage();

  // Trigger a frame.
  await tester.pumpAndSettle();
  await binding.takeScreenshot(name);
  if (!silent) print('Screenshot $name created');
}
