import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String parseTheme(BuildContext context) {
  final mode = AdaptiveTheme.of(context).mode;
  if (mode.isLight) {
    return AppLocalizations.of(context).light;
  } else if (mode.isDark) {
    return AppLocalizations.of(context).dark;
  } else {
    return AppLocalizations.of(context).system;
  }
}

String parseLanguageCode(String languageTag) {
  switch (languageTag) {
    case 'en':
      return 'English';
    case 'es':
    default:
      return 'Español';
  }
}

String parseDuration(Duration duration) {
  final iH = duration.inHours;
  final iM = duration.inMinutes % 60;
  final iS = duration.inSeconds % 60;
  final h = iH == 0 ? '' : '$iH:';
  final m = iM < 10 && iH != 0 ? '0$iM' : iM;
  final s = iS < 10 ? '0$iS' : iS;
  return '$h$m:$s';
}
