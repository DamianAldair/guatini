import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/providers/userpreferences_provider.dart';

class OnlineUsePage extends StatefulWidget {
  const OnlineUsePage({Key? key}) : super(key: key);

  @override
  State<OnlineUsePage> createState() => _OnlineUsePageState();
}

class _OnlineUsePageState extends State<OnlineUsePage> {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).onlineUse),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context).wikiSearch),
            value: prefs.wikipediaOnline,
            onChanged: (value) => setState(() => prefs.wikipediaOnline = value),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context).onlineImage),
            value: prefs.imageOnline,
            onChanged: (value) => setState(() => prefs.imageOnline = value),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context).onlineAudio),
            value: prefs.audioOnline,
            onChanged: (value) => setState(() => prefs.audioOnline = value),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context).onlineVideo),
            value: prefs.videoOnline,
            onChanged: (value) => setState(() => prefs.videoOnline = value),
          ),
        ],
      ),
    );
  }
}
