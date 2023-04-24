import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/wiki_models.dart';

abstract class WikipediaProvider {
  static String _getApiUrl(BuildContext context) {
    final locale = AppLocalizations.of(context).localeName.toLowerCase();
    return 'https://$locale.wikipedia.org/w/api.php';
  }

  static Future<WikiResults> search(BuildContext context, String query) async {
    final response = await Dio().get(
      _getApiUrl(context),
      queryParameters: {
        "action": "opensearch",
        "format": "json",
        "search": query,
      },
    );
    return WikiResults.fromResponse(response.data);
  }
}
