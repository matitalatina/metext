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

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      localizations = c.jsonDecode(await driver.requestData(null));
    });

    test('loads sample text', () async {
      await screenshot(driver, config, '1');
      await driver.tap(chooseByLibraryBtn);
    });

    test('tap on items', () async {
      expect(await driver.getText(selectPageTitle), contains('0'));
      await driver.tap(selectListItemFirst);
      await driver.tap(selectListItemSecond);
      expect(await driver.getText(selectPageTitle), contains('2'));
      await screenshot(driver, config, '2');
      await driver.tap(selectPageContinueBtn);
      await screenshot(driver, config, '2');
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
  });
}