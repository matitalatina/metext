import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:metext/i18n/l10n.dart';
import 'package:metext/main.dart' as app;
import 'dart:convert' as c;
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  final DataHandler handler = (_) async {
    final localizations = AppL10n(Locale(ui.window.locale.languageCode));
    final response = {
      'sourceFromGallery': localizations.sourceFromGallery,
      'selectPageContinue': localizations.selectPageContinue,
      'locale': Intl.defaultLocale,
    };
    return Future.value(c.jsonEncode(response));
  };

  enableFlutterDriverExtension(handler: handler);
  WidgetsApp.debugAllowBannerOverride = false;

  const MethodChannel channel =
  MethodChannel('plugins.flutter.io/image_picker');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    ByteData data = await rootBundle.load('assets/test/sample-text.png');
    Uint8List bytes = data.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/tmp.tmp', ).writeAsBytes(bytes);
    print(file.path);
    return file.path;
  });

  app.main();
}