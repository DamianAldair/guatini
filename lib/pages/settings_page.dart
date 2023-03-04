import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/language_page.dart';
import 'package:guatini/pages/themes_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.library_books_rounded),
            title: Text(AppLocalizations.of(context).database),
            subtitle:
                Text(UserPreferences().dbPath ?? 'No hay DB seleccionada'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            title: Text(AppLocalizations.of(context).theme),
            subtitle: Text(parseTheme(context)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemesPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(AppLocalizations.of(context).language),
            subtitle: Text(AppLocalizations.of(context).languageName),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LanguagePage()),
            ),
          ),
        ],
      ),
    );
  }
}
