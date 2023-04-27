import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guatini/pages/wiki_search_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

// enum QrResultMode {
//   offline('offline'),
//   wikipedia('wikipedia'),
//   link('link'),
//   invalid('invalid');

//   final String mode;
//   const QrResultMode(this.mode);
//   factory QrResultMode.fromString(String mode) {
//     switch (mode) {
//       case 'link':
//         return QrResultMode.link;
//       case 'wikipedia':
//         return QrResultMode.wikipedia;
//       case 'offline':
//         return QrResultMode.offline;
//       default:
//         return QrResultMode.invalid;
//     }
//   }
// }

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

  Future<bool> launchUrl() => url_launcher.launchUrl(uri);
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

  factory QrWikipedia.fromJson(
      BuildContext context, Map<String, dynamic> json) {
    final lang =
        json["locale"] ?? UserPreferences().locale!.languageCode.toLowerCase();
    return QrWikipedia(
      language: lang,
      query: json["query"]!,
    );
  }

  Future executeSearch(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WikiSearchPage(language, query)),
      );
}
