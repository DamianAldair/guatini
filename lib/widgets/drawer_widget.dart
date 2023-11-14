import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/about_page.dart';
import 'package:guatini/pages/games_page.dart';
import 'package:guatini/pages/map_page.dart';
import 'package:guatini/pages/qr_scanner_page.dart';
import 'package:guatini/pages/settings_page.dart';
import 'package:guatini/providers/appinfo_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _itemList(context),
      ),
    );
  }

  List<Widget> _itemList(BuildContext context) {
    List<Widget> list = [];
    list.add(
      DrawerHeader(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/drawer_header.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomRight,
          child: Text(
            AppInfo().appName,
            style: const TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 255, 255, 255),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
    for (_Route pageRoute in _drawerPagesRoutes(context)) {
      list.add(
        ListTile(
          leading: Icon(pageRoute.icon),
          title: Text(pageRoute.title),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => pageRoute.page),
            );
          },
        ),
      );
    }
    return list;
  }
}

class _Route {
  final bool isMainPage;
  final IconData icon;
  final String title;
  final Widget page;

  _Route({
    required this.isMainPage,
    required this.icon,
    required this.title,
    required this.page,
  });
}

List<_Route> _drawerPagesRoutes(BuildContext context) => [
      if (UserPreferences().dbPathNotifier.value != null)
        _Route(
          isMainPage: false,
          icon: Icons.qr_code_scanner_rounded,
          title: AppLocalizations.of(context).openQrReader,
          page: const QrScannerPage(),
        ),
      if (UserPreferences().dbPathNotifier.value != null)
        _Route(
          isMainPage: false,
          icon: Icons.map_rounded,
          title: AppLocalizations.of(context).map,
          page: const MapPage(),
        ),
      if (UserPreferences().dbPathNotifier.value != null)
        _Route(
          isMainPage: false,
          icon: Icons.gamepad_rounded,
          title: AppLocalizations.of(context).games,
          page: const GamesPage(),
        ),
      _Route(
        isMainPage: false,
        icon: Icons.settings_rounded,
        title: AppLocalizations.of(context).settings,
        page: const SettingsPage(),
      ),
      _Route(
        isMainPage: false,
        icon: Icons.info_outline_rounded,
        title: AppLocalizations.of(context).about,
        page: const AboutPage(),
      ),
    ];
