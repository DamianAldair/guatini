import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';

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

List<SpeciesModel> joinEquals(List<SpeciesModel> list) {
  List<SpeciesModel> result = [];
  String sname = '';
  String cname = '';
  for (int i = 0; i < list.length; i++) {
    final s = list[i];
    if (sname != s.scientificName) {
      sname = s.scientificName.toString();
    }
    if (sname == s.scientificName) {
      cname += '${s.searchName}\n';
    }
    if ((i + 1 < list.length && sname != list[i + 1].scientificName) ||
        i + 1 >= list.length) {
      final json = {
        "id": s.id,
        "name": cname.substring(0, cname.length - 1),
        "scientific_name": sname,
        "path": s.imagePath,
      };
      result.add(SpeciesModel.fromSimpleSearch(json));
      cname = '';
    }
  }
  return result;
}
