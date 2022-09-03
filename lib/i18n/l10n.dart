import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:metext/i18n/en.dart';
import 'package:metext/i18n/it.dart';

final _MISSING_VALUE = 'XXX';

class AppL10n {
  final Locale locale;

  AppL10n(this.locale);

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static Map<String, Map<String, String>> _localizedValues = {
    ...appEnValues,
    ...appItValues,
  };

  String get permissionPhotoAccessDeniedTitle {
    return _localizedValues[locale.languageCode]?
        ['Permission.PhotoAccessDenied.Title'] ?? _MISSING_VALUE;
  }

  String get permissionPhotoAccessDeniedDescription {
    return _localizedValues[locale.languageCode]?
        ['Permission.PhotoAccessDenied.Description'] ?? _MISSING_VALUE;
  }


  String get permissionCameraAccessDeniedDescription {
    return _localizedValues[locale.languageCode]?
    ['Permission.CameraAccessDenied.Description'] ?? _MISSING_VALUE;
  }

  String get ok {
    return _localizedValues[locale.languageCode]?['Ok'] ?? _MISSING_VALUE;
  }

  String get sourceFromCamera {
    return _localizedValues[locale.languageCode]?['Source.FromCamera'] ?? _MISSING_VALUE;
  }

  String get sourceFromGallery {
    return _localizedValues[locale.languageCode]?['Source.FromGallery'] ?? _MISSING_VALUE;
  }

  String get editPageTitle {
    return _localizedValues[locale.languageCode]?['EditPage.Title'] ?? _MISSING_VALUE;
  }

  String get editPageCopy {
    return _localizedValues[locale.languageCode]?['EditPage.Copy'] ?? _MISSING_VALUE;
  }

  String get editPageCopied {
    return _localizedValues[locale.languageCode]?['EditPage.Copied'] ?? _MISSING_VALUE;
  }

  String get editPageShare {
    return _localizedValues[locale.languageCode]?['EditPage.Share'] ?? _MISSING_VALUE;
  }

  String get editPageShareContentSubject {
    return _localizedValues[locale.languageCode]
        ?['EditPage.Share.Content.Subject'] ?? _MISSING_VALUE;
  }

  String get selectPageSelectAll {
    return _localizedValues[locale.languageCode]?['SelectPage.SelectAll'] ?? _MISSING_VALUE;
  }

  String get selectPageDeselectAll {
    return _localizedValues[locale.languageCode]?['SelectPage.DeselectAll'] ?? _MISSING_VALUE;
  }

  String get selectPageContinue {
    return _localizedValues[locale.languageCode]?['SelectPage.Continue'] ?? _MISSING_VALUE;
  }

  String get selectPageSelectedBlock {
    return _localizedValues[locale.languageCode]?['SelectPage.SelectedBlock'] ?? _MISSING_VALUE;
  }

  String get selectPageSelectedBlocks {
    return _localizedValues[locale.languageCode]?['SelectPage.SelectedBlocks'] ?? _MISSING_VALUE;
  }
}
