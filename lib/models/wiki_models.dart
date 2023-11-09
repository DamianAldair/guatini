import 'package:url_launcher/url_launcher.dart' as url_launcher;

class WikiResults {
  String query;
  List<WikiResult> results;

  WikiResults({
    required this.query,
    required this.results,
  });

  factory WikiResults.fromResponse(dynamic response) {
    final data = response as List<dynamic>;
    final res = <WikiResult>[];
    for (int i = 0; i < (data[1] as List<dynamic>).length; i++) {
      res.add(WikiResult(
        name: (data[1] as List<dynamic>)[i] as String,
        url: Uri.parse((data[3] as List<dynamic>)[i] as String),
      ));
    }
    return WikiResults(
      query: data[0] as String,
      results: res,
    );
  }
}

class WikiResult {
  String name;
  Uri url;

  WikiResult({
    required this.name,
    required this.url,
  });

  // ignore: deprecated_member_use
  Future<bool> launchUrl(bool inApp) => inApp ? url_launcher.launchUrl(url) : url_launcher.launch(url.toString());
}
