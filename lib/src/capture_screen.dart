import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:screenshots/src/globals.dart';

import 'config.dart';

/// Called by integration test to capture images.
Future<void> screenshotDriver(Config config,
    {bool silent = false, bool waitUntilNoTransientCallbacks = true}) async {
  return integrationDriver(
    onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
      if (config.isScreenShotsAvailable) {
        // todo: auto-naming scheme
        final testDir = '${config.stagingDir}/$kTestScreenshotsDir';
        final file = await File('$testDir/$screenshotName.$kImageExtension')
            .create(recursive: true);
        await file.writeAsBytes(screenshotBytes);
        if (!silent) print('Screenshot $screenshotName created');
        return true;
      } else {
        if (!silent) print('Warning: screenshot $screenshotName not created');
        return false;
      }
    },
  );
}
