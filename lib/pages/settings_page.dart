import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/databases_page.dart';
import 'package:guatini/pages/language_page.dart';
import 'package:guatini/pages/online_page.dart';
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
            subtitle: StreamBuilder(
              stream: UserPreferences().dbPathStream,
              builder: (_, AsyncSnapshot<String> snapshot) {
                final String path;
                if (!snapshot.hasData) {
                  path = UserPreferences().dbPath;
                } else {
                  path = snapshot.data!;
                }
                return Text(
                  path.isEmpty
                      ? AppLocalizations.of(context).notSelected
                      : '${AppLocalizations.of(context).current}: $path',
                );
              },
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DatabasesPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new_rounded),
            title: Text(AppLocalizations.of(context).onlineUse),
            subtitle: Text(AppLocalizations.of(context).onlineUseText),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnlineUsePage()),
            ),
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
