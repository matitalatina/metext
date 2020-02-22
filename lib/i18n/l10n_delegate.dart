import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:metext/i18n/l10n.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppL10n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'it'].contains(locale.languageCode);

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(AppL10n(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
