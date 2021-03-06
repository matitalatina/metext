import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

class Secrets {
  static Future<String> getString(String property) async {
    List<String> propertyKeys = property.split(".");
    var ymlFile = loadYaml(await rootBundle.loadString('assets/secrets.yml'));
    return propertyKeys.fold(ymlFile, (ymlFile, path) => ymlFile[path]).toString();
  }

  static Future<String> getAdmobAppId() async {
    return await Secrets.getString("app.admob_app_id");
  }
}