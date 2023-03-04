import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemesPage extends StatelessWidget {
  const ThemesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).theme),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_auto_rounded),
            title: Text(AppLocalizations.of(context).system),
            trailing: Icon(AdaptiveTheme.of(context).mode.isSystem
                ? Icons.radio_button_on
                : Icons.radio_button_off),
            onTap: () => AdaptiveTheme.of(context).setSystem(),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_7_rounded),
            title: Text(AppLocalizations.of(context).light),
            trailing: Icon(AdaptiveTheme.of(context).mode.isLight
                ? Icons.radio_button_on
                : Icons.radio_button_off),
            onTap: () => AdaptiveTheme.of(context).setLight(),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_2_rounded),
            title: Text(AppLocalizations.of(context).dark),
            trailing: Icon(AdaptiveTheme.of(context).mode.isDark
                ? Icons.radio_button_on
                : Icons.radio_button_off),
            onTap: () => AdaptiveTheme.of(context).setDark(),
          ),
        ],
      ),
    );
  }
}
