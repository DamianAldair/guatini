import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guatini/pages/databases_page.dart';
import 'package:guatini/pages/language_page.dart';
import 'package:guatini/pages/online_page.dart';
import 'package:guatini/pages/themes_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.database),
            title: Text(AppLocalizations.of(context).database),
            subtitle: ValueListenableBuilder(
              valueListenable: prefs.dbPathNotifier,
              builder: (_, String? path, __) {
                return Text(
                  path == null
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
            leading: const Icon(Icons.manage_search_outlined),
            title: Text(AppLocalizations.of(context).searchHistotySize),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: () => setState(() => prefs.numberOfLastSearches--),
                ),
                Text(
                  prefs.numberOfLastSearches.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => setState(() => prefs.numberOfLastSearches++),
                ),
              ],
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.play_arrow_rounded),
            title: Text(AppLocalizations.of(context).autoplayAudio),
            subtitle: Text(AppLocalizations.of(context).autoplayAudioInfo),
            value: prefs.autoplayAudio,
            onChanged: (bool value) => setState(() => prefs.autoplayAudio = value),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.ondemand_video_rounded),
            title: Text(AppLocalizations.of(context).autoplayVideo),
            subtitle: Text(AppLocalizations.of(context).autoplayVideoInfo),
            value: prefs.autoplayVideo,
            onChanged: (bool value) => setState(() => prefs.autoplayVideo = value),
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
