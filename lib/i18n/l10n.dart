import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:metext/i18n/en.dart';
import 'package:metext/i18n/it.dart';

class AppL10n {
  final Locale locale;

  AppL10n(this.locale);

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    ...appEnValues,
    ...appItValues,
  };

  String get permissionPhotoAccessDeniedTitle {
    return _localizedValues[locale.languageCode]
        ['Permission.PhotoAccessDenied.Title'];
  }

  String get permissionPhotoAccessDeniedDescription {
    return _localizedValues[locale.languageCode]
        ['Permission.PhotoAccessDenied.Description'];
  }

  String get ok {
    return _localizedValues[locale.languageCode]['Ok'];
  }

  String get sourceFromCamera {
    return _localizedValues[locale.languageCode]['Source.FromCamera'];
  }

  String get sourceFromGallery {
    return _localizedValues[locale.languageCode]['Source.FromGallery'];
  }

  String get editPageTitle {
    return _localizedValues[locale.languageCode]['EditPage.Title'];
  }

  String get editPageCopy {
    return _localizedValues[locale.languageCode]['EditPage.Copy'];
  }

  String get editPageCopied {
    return _localizedValues[locale.languageCode]['EditPage.Copied'];
  }

  String get editPageShare {
    return _localizedValues[locale.languageCode]['EditPage.Share'];
  }

  String get editPageShareContentSubject {
    return _localizedValues[locale.languageCode]
        ['EditPage.Share.Content.Subject'];
  }

  String get selectPageSelectAll {
    return _localizedValues[locale.languageCode]['SelectPage.SelectAll'];
  }

  String get selectPageDeselectAll {
    return _localizedValues[locale.languageCode]['SelectPage.DeselectAll'];
  }

  String get selectPageContinue {
    return _localizedValues[locale.languageCode]['SelectPage.Continue'];
  }

  String get selectPageSelectedBlock {
    return _localizedValues[locale.languageCode]['SelectPage.SelectedBlock'];
  }

  String get selectPageSelectedBlocks {
    return _localizedValues[locale.languageCode]['SelectPage.SelectedBlocks'];
  }
}
