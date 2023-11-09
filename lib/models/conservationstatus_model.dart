import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ConservationStatusModel {
  final int? id;
  final String? status;

  const ConservationStatusModel({
    required this.id,
    required this.status,
  });

  factory ConservationStatusModel.fromMap(Map<String, dynamic> json) => ConservationStatusModel(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
      };

  // String getConservationText(BuildContext context) {
  //   String conservation = '';
  //   switch (status) {
  //     case 1:
  //       conservation = AppLocalizations.of(context).extinct;
  //       break;
  //     case 2:
  //       conservation = AppLocalizations.of(context).extinctInTheWild;
  //       break;
  //     case 3:
  //       conservation = AppLocalizations.of(context).criticalEndangered;
  //       break;
  //     case 4:
  //       conservation = AppLocalizations.of(context).endangered;
  //       break;
  //     case 5:
  //       conservation = AppLocalizations.of(context).vulnerable;
  //       break;
  //     case 6:
  //       conservation = AppLocalizations.of(context).nearThreataned;
  //       break;
  //     case 7:
  //       conservation = AppLocalizations.of(context).leastConcern;
  //       break;
  //     case 8:
  //       conservation = AppLocalizations.of(context).deficientData;
  //       break;
  //     case 9:
  //       conservation = AppLocalizations.of(context).notEvaluated;
  //       break;
  //     default:
  //       conservation = AppLocalizations.of(context).errorObtainingInfo;
  //       break;
  //   }
  //   return conservation;
  // }

  List<Widget> getConservationIconList(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).brightness == Brightness.dark;
    final iconSize = MediaQuery.of(context).size.width / 10;
    const defaultBgColor = Color.fromARGB(125, 240, 240, 240);
    const defaultFgColor = Color.fromARGB(125, 0, 0, 0);

    final alias = <int, String>{
      1: 'EX',
      2: 'EW',
      3: 'CE',
      4: 'EN',
      5: 'VU',
      6: 'NT',
      7: 'LC',
      8: 'DD',
    };
    final bgColors = <int, Color>{
      1: isDark ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
      2: isDark ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
      3: const Color.fromARGB(255, 204, 51, 51),
      4: const Color.fromARGB(255, 204, 102, 51),
      5: const Color.fromARGB(255, 204, 159, 0),
      6: const Color.fromARGB(255, 0, 102, 102),
      7: const Color.fromARGB(255, 0, 102, 102),
    };
    final fgColors = <int, Color>{
      1: const Color.fromARGB(255, 207, 52, 52),
      2: isDark ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255),
      3: const Color.fromARGB(255, 252, 193, 193),
      4: const Color.fromARGB(255, 247, 188, 137),
      5: const Color.fromARGB(255, 255, 255, 255),
      6: const Color.fromARGB(255, 113, 177, 140),
      7: const Color.fromARGB(255, 255, 255, 255),
    };

    return List.generate((id! < 1 || id! > 7) ? 2 : 7, (index) {
      final i = index + ((id! < 1 || id! > 7) ? 8 : 1);
      final active = id! == i;
      return Opacity(
        opacity: active ? 1.0 : 0.4,
        child: Container(
          height: iconSize,
          width: iconSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? bgColors[i] ?? const Color.fromARGB(255, 55, 55, 135) : defaultBgColor,
            borderRadius: BorderRadius.circular(iconSize),
            border: active ? null : Border.all(color: defaultFgColor),
          ),
          child: Text(
            alias[i] ?? 'NE',
            style: TextStyle(color: active ? fgColors[i] ?? const Color.fromARGB(255, 255, 255, 255) : defaultFgColor),
          ),
        ),
      );
    });
  }
}
