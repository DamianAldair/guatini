import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guatini/pages/databases_page.dart';
import 'package:guatini/pages/language_page.dart';
import 'package:guatini/pages/onboarding_screen.dart';
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
          TitleDivider(AppLocalizations.of(context).sourceOfInfo),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: FaIcon(FontAwesomeIcons.database),
            ),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DatabasesPage()),
              );
              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              prefs.dbPathNotifier.notifyListeners();
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.language_rounded),
            ),
            title: Text(AppLocalizations.of(context).onlineUse),
            subtitle: Text(AppLocalizations.of(context).onlineUseText),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnlineUsePage()),
            ),
          ),
          TitleDivider(AppLocalizations.of(context).ui),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.brightness_6_rounded),
            ),
            title: Text(AppLocalizations.of(context).theme),
            subtitle: Text(parseTheme(context)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemesPage()),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: FaIcon(FontAwesomeIcons.language),
            ),
            title: Text(AppLocalizations.of(context).language),
            subtitle: Text(AppLocalizations.of(context).languageName),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LanguagePage()),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.home_rounded),
            ),
            title: Text(AppLocalizations.of(context).numberSeggestions),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: () => setState(() => prefs.suggestions--),
                ),
                Text(
                  prefs.suggestions.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => setState(() => prefs.suggestions++),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.manage_search_outlined),
            ),
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
          TitleDivider(AppLocalizations.of(context).players),
          SwitchListTile(
            secondary: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(FontAwesomeIcons.circlePlay),
            ),
            title: Text(AppLocalizations.of(context).autoplayAudio),
            subtitle: Text(AppLocalizations.of(context).autoplayAudioInfo),
            value: prefs.autoplayAudio,
            onChanged: (bool value) => setState(() => prefs.autoplayAudio = value),
          ),
          SwitchListTile(
            secondary: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.ondemand_video_rounded),
            ),
            title: Text(AppLocalizations.of(context).autoplayVideo),
            subtitle: Text(AppLocalizations.of(context).autoplayVideoInfo),
            value: prefs.autoplayVideo,
            onChanged: (bool value) => setState(() => prefs.autoplayVideo = value),
          ),
          TitleDivider(AppLocalizations.of(context).others),
          SwitchListTile(
            secondary: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: FaIcon(FontAwesomeIcons.rectangleAd),
            ),
            title: Text(AppLocalizations.of(context).showAds),
            subtitle: Text(AppLocalizations.of(context).showAdsText),
            value: prefs.showAds,
            onChanged: (bool value) => setState(() => prefs.showAds = value),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: FaIcon(FontAwesomeIcons.gamepad),
            ),
            title: Text(AppLocalizations.of(context).resetGameScores),
            onTap: () => prefs.resetGames().then((reseted) {
              if (reseted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).gameScoresReset),
                  ),
                );
              }
            }),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.switch_access_shortcut_rounded),
            ),
            title: Text(AppLocalizations.of(context).wizardAgain),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleDivider extends StatelessWidget {
  final String? text;

  const TitleDivider(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text == null) return const Divider();
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          text!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
