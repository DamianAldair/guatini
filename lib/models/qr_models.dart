// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/conservationstatus_model.dart';
import 'package:guatini/pages/characteristic_page.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/pages/wiki_search_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/providers/wikipedia_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

abstract class QrResult {}

/// Example of JSON:
/// {
///   "guatini_qr_data": {
///     "link": "https://www.google.com"
///   }
/// }
class QrLink extends QrResult {
  final String url;

  QrLink({required this.url});

  Uri get uri => Uri.parse(url);

  Future<bool> launchUrl() =>
      // ignore: deprecated_member_use
      !UserPreferences().externalBrowser ? url_launcher.launchUrl(uri) : url_launcher.launch(url.toString());
}

/// Expample of JSON:
/// {
///   "guatini_qr_data": {
///     "wikipedia": {
///       "locale": "es",
///       "query": "xyz"
///     }
///   }
/// }
class QrWikipedia extends QrResult {
  final String? language;
  final String query;

  QrWikipedia({
    this.language,
    required this.query,
  });

  factory QrWikipedia.fromJson(BuildContext context, Map<String, dynamic> json) {
    final lang = json["locale"] ?? UserPreferences().locale!.languageCode.toLowerCase();
    return QrWikipedia(
      language: lang,
      query: json["query"]!,
    );
  }

  Future executeSearch(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MediawikiSearchPage(
            source: MediawikiSearch.wikipedia,
            query: query,
            lang: language,
          ),
        ),
      );
}

/// Expample of JSON:
/// {
///   "guatini_qr_data": {
///     "ecured": {
///       "query": "xyz"
///     }
///   }
/// }
class QrEcured extends QrResult {
  final String query;

  QrEcured({
    required this.query,
  });

  factory QrEcured.fromJson(Map<String, dynamic> json) => QrEcured(query: json["query"]!);

  Future executeSearch(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MediawikiSearchPage(
            source: MediawikiSearch.ecured,
            query: query,
          ),
        ),
      );
}

/// Expample of JSON:
/// {
///   "guatini_qr_data": {
///     "offline": {
///       "species": "Priotelus temnurus"
///     }
///   }
/// }
class QrOffline extends QrResult {
  final String? species;
  final String? taxGenus;
  final String? taxFamily;
  final String? taxOrder;
  final String? taxClass;
  final String? taxPhylum;
  final String? taxKingdom;
  final String? taxDomain;
  final int? conservationStatus;
  final String? endemism;
  final String? abundance;
  final String? activity;
  final String? habitat;
  final String? diet;
  final String? author;
  final String? license;

  QrOffline({
    this.species,
    this.taxGenus,
    this.taxFamily,
    this.taxOrder,
    this.taxClass,
    this.taxPhylum,
    this.taxKingdom,
    this.taxDomain,
    this.conservationStatus,
    this.endemism,
    this.abundance,
    this.activity,
    this.habitat,
    this.diet,
    this.author,
    this.license,
  }) : assert([
              species,
              taxGenus,
              taxFamily,
              taxOrder,
              taxClass,
              taxPhylum,
              taxKingdom,
              taxDomain,
              conservationStatus,
              endemism,
              abundance,
              activity,
              habitat,
              diet,
              author,
              license,
            ].where((e) => e != null).length ==
            1);

  factory QrOffline.fromJson(Map<String, dynamic> json) {
    final cons = json["conservationStatus"] == null
        ? null
        : json["conservationStatus"] is int
            ? json["conservationStatus"]
            : int.tryParse(json["conservationStatus"]);
    return QrOffline(
      species: json["species"],
      taxGenus: json["genus"],
      taxFamily: json["family"],
      taxOrder: json["order"],
      taxClass: json["class"],
      taxPhylum: json["phylum"],
      taxKingdom: json["kingdom"],
      taxDomain: json["domain"],
      conservationStatus: cons,
      endemism: json["endemism"],
      abundance: json["abundance"],
      activity: json["activity"],
      habitat: json["habitat"],
      diet: json["diet"],
      author: json["author"],
      license: json["license"],
    );
  }

  Future<void> executeSearch(BuildContext context) async {
    final Database db = (await DbProvider.database)!;
    String errorText = '';
    if (species != null) {
      final id = await SearchProvider.getIdFromScientificName(db, species!);
      if (id <= 0) {
        errorText = species!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SpeciesDetailsPage(id)),
        );
      }
    } else if (taxGenus != null) {
      final g = await SearchProvider.getGenusByName(db, taxGenus!);
      if (g == null) {
        errorText = taxGenus!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxGenus,
              instance: g,
            ),
          ),
        );
      }
    } else if (taxFamily != null) {
      final f = await SearchProvider.getFamilyByName(db, taxFamily!);
      if (f == null) {
        errorText = taxFamily!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxFamily,
              instance: f,
            ),
          ),
        );
      }
    } else if (taxOrder != null) {
      final o = await SearchProvider.getOrderByName(db, taxOrder!);
      if (o == null) {
        errorText = taxOrder!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxOrder,
              instance: o,
            ),
          ),
        );
      }
    } else if (taxClass != null) {
      final c = await SearchProvider.getClassByName(db, taxClass!);
      if (c == null) {
        errorText = taxClass!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxClass,
              instance: c,
            ),
          ),
        );
      }
    } else if (taxPhylum != null) {
      final f = await SearchProvider.getPhyumByName(db, taxPhylum!);
      if (f == null) {
        errorText = taxPhylum!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxPhylum,
              instance: f,
            ),
          ),
        );
      }
    } else if (taxKingdom != null) {
      final k = await SearchProvider.getKingdomByName(db, taxKingdom!);
      if (k == null) {
        errorText = taxKingdom!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxKingdom,
              instance: k,
            ),
          ),
        );
      }
    } else if (taxDomain != null) {
      final d = await SearchProvider.getDomainByName(db, taxDomain!);
      if (d == null) {
        errorText = taxDomain!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).taxDomain,
              instance: d,
            ),
          ),
        );
      }
    } else if (conservationStatus != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharacteristicPage(
            title: AppLocalizations.of(context).conservationStatus,
            instance: ConservationStatusModel(
              id: conservationStatus,
              status: null,
            ),
          ),
        ),
      );
    } else if (endemism != null) {
      final e = await SearchProvider.getEndemismByName(db, endemism!);
      if (e == null) {
        errorText = endemism!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).endemism,
              instance: e,
            ),
          ),
        );
      }
    } else if (abundance != null) {
      final a = await SearchProvider.getAbundanceByName(db, abundance!);
      if (a == null) {
        errorText = abundance!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).abundance,
              instance: a,
            ),
          ),
        );
      }
    } else if (activity != null) {
      final a = await SearchProvider.getActivityByName(db, activity!);
      if (a == null) {
        errorText = activity!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).activity,
              instance: a,
            ),
          ),
        );
      }
    } else if (habitat != null) {
      final h = await SearchProvider.getHabitatByName(db, habitat!);
      if (h == null) {
        errorText = habitat!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).habitat,
              instance: h,
            ),
          ),
        );
      }
    } else if (diet != null) {
      final d = await SearchProvider.getDietByName(db, diet!);
      if (d == null) {
        errorText = diet!;
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacteristicPage(
              title: AppLocalizations.of(context).diet,
              instance: d,
            ),
          ),
        );
      }
    }
    if (errorText.isNotEmpty) {
      return Future.error(errorText);
    }
  }
}
