import 'package:url_launcher/url_launcher.dart' as url_launcher;

enum QrResultMode {
  offline('offline'),
  wikipedia('wikipedia'),
  link('link');

  final String mode;
  const QrResultMode(this.mode);
}

class QrResult {
  final QrResultMode mode;
  final QrResultData data;

  QrResult({
    required this.mode,
    required this.data,
  });
}

abstract class QrResultData {}

class QrLink extends QrResultData {
  final String url;

  QrLink({required this.url});

  Uri get uri => Uri.parse(url);

  Future<bool> launchUrl() => url_launcher.launchUrl(uri);
}

class QrWikipedia extends QrResultData {
  final String? language;
  final String query;

  QrWikipedia({
    this.language,
    required this.query,
  });
}
