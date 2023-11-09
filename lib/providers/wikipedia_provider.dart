import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/wiki_models.dart';

enum MediawikiSearch {
  wikipedia,
  ecured,
}

abstract class WikipediaProvider {
  static String _getApiUrl(BuildContext context, MediawikiSearch source, String? lang) {
    final locale = lang ?? AppLocalizations.of(context).localeName.toLowerCase();
    final api = switch (source) {
      MediawikiSearch.wikipedia => '$locale.wikipedia.org/w',
      MediawikiSearch.ecured => 'www.ecured.cu',
    };
    return 'https://$api/api.php';
  }

  static Future<WikiResults> search({
    required BuildContext context,
    required MediawikiSearch source,
    required String? lang,
    required String query,
  }) async {
    try {
      final response = await Dio().get(
        _getApiUrl(context, source, lang),
        queryParameters: {
          "action": "opensearch",
          "format": "json",
          "search": query,
        },
      );
      return WikiResults.fromResponse(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }
}
