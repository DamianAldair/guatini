import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/game_models.dart';
import 'package:guatini/pages/game1_page.dart';
import 'package:guatini/pages/game2_page.dart';
import 'package:guatini/pages/game3_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final games = [
      _Game(
        id: 1,
        icon: Icons.font_download_rounded,
        name: AppLocalizations.of(context).gameSelectSNameFromCName,
        page: const Game1Page(1),
      ),
      _Game(
        id: 2,
        icon: Icons.image_rounded,
        name: AppLocalizations.of(context).gameSelectImageFromCName,
        page: const Game2Page(2),
      ),
      _Game(
        id: 3,
        icon: Icons.audiotrack_rounded,
        name: AppLocalizations.of(context).gameSelectCNameFromSound,
        page: const Game3Page(3),
      ),
    ];

    final prefs = UserPreferences();
    for (_Game g in games) {
      prefs.addGame(GameModel(id: g.id, record: 0));
    }

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        return true;
      },
      child: ValueListenableBuilder(
        valueListenable: prefs.gamesNotifier,
        builder: (_, List<GameModel> gamelist, ___) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).games),
            ),
            body: ListView.builder(
              itemCount: games.length,
              itemBuilder: (_, int i) {
                final game = games[i];
                int hitsInARow = gamelist.where((e) => e.id == game.id).isEmpty
                    ? 0
                    : gamelist.where((e) => e.id == game.id).first.record;
                return ListTile(
                  title: Text(game.name),
                  subtitle: Text('Record: ${AppLocalizations.of(context).inARow(hitsInARow)}'),
                  leading: CircleAvatar(child: Icon(game.icon ?? Icons.games_rounded)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => game.page),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Game {
  final int id;
  final IconData? icon;
  final String name;
  final Widget page;

  _Game({
    required this.id,
    required this.icon,
    required this.name,
    required this.page,
  });
}
