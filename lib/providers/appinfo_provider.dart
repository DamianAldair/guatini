import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class AppInfo {
  static final AppInfo _instance = AppInfo._();
  AppInfo._();
  factory AppInfo() => _instance;

  PackageInfo? _info;

  Future<void> initialize() async {
    _info = await PackageInfo.fromPlatform();
  }

  String get appName => _info!.appName;

  String get buildNumber => _info!.buildNumber;

  String get buildSignature => _info!.buildSignature;

  String getInstallerStore(BuildContext context) =>
      _info!.installerStore ?? AppLocalizations.of(context).unknown;

  String get packageName => _info!.packageName;

  Version get version => Version.parse(_info!.version);

  final String developer = 'Damian Aldair';

  String getDepartment(BuildContext context) =>
      AppLocalizations.of(context).college;

  String getOrganization(BuildContext context) =>
      '${AppLocalizations.of(context).university}\n"José Antonio Echeverría"';

  final String organizationLite = 'CUJAE';

  String get copyright {
    const compilationYear = 2022;
    final currentYear = DateTime.now().year;
    final copyrightYears = compilationYear == currentYear
        ? compilationYear.toString()
        : '${compilationYear.toString()} - ${currentYear.toString()}';
    return '© $copyrightYears $organizationLite';
  }
}
