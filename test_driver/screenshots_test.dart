import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:convert' as c;
import 'package:screenshots/screenshots.dart';

void main() {
  group('Screenshots', () {
    final config = Config();
    Map localizations;
    final chooseByLibraryBtn = find.byValueKey("chooseSource-byLibrary-btn");
    final selectPageTitle = find.byValueKey("selectPage-title");
    final selectPageContinueBtn = find.byValueKey("selectPage-continueBtn");
    final selectListItemFirst = find.byValueKey("selectPage-listTile-0");
    final selectListItemSecond = find.byValueKey("selectPage-listTile-1");
    bool isDarkMode;

    FlutterDriver driver;
    setUpAll(() async {
      String response = (await Process.run('adb', ['shell', 'settings', 'get', 'secure', 'ui_night_mode'])).stdout;
      isDarkMode = int.parse(response.replaceAll('\n', '')) == 2;

      driver = await FlutterDriver.connect();
      localizations = c.jsonDecode(await driver.requestData(null));

    });

    test('loads sample text', () async {
      await screenshot(driver, config, getScreenshotId(1, isDarkMode));
      await driver.tap(chooseByLibraryBtn);
    });

    test('tap on items', () async {
      expect(await driver.getText(selectPageTitle), contains('0'));
      await driver.tap(selectListItemFirst);
      await driver.tap(selectListItemSecond);
      expect(await driver.getText(selectPageTitle), contains('2'));
      await screenshot(driver, config, getScreenshotId(2, isDarkMode));
      await driver.tap(selectPageContinueBtn);
      await screenshot(driver, config, getScreenshotId(3, isDarkMode));
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
  });
}

String getScreenshotId(int index, bool isDarkMode) {
  return (index + (isDarkMode ? 0 : 3)).toString();
}