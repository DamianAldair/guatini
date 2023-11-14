import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/game_models.dart';
import 'package:guatini/pages/game1_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  void didChangeDependencies() {
    final prefs = UserPreferences();
    prefs.gamesStream.listen((_) => setState(() {}));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final games = [
      _Game(
        id: 1,
        name: AppLocalizations.of(context).gameSelectSNameFromCName,
        page: const Game1Page(),
      ),
    ];

    final prefs = UserPreferences();
    for (_Game g in games) {
      prefs.addGame(GameModel(id: g.id, record: 0));
    }
    final models = prefs.games;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).games),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (_, int i) {
          final game = games[i];
          int hitsInARow =
              models.where((e) => e.id == game.id).isEmpty ? 0 : models.where((e) => e.id == game.id).first.record;
          return ListTile(
            title: Text(game.name),
            subtitle: Text('Record: ${AppLocalizations.of(context).inARow(hitsInARow)}'),
            leading: const CircleAvatar(child: Icon(Icons.games_rounded)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => game.page),
            ),
          );
        },
      ),
    );
  }
}

class _Game {
  final int id;
  final String name;
  final Widget page;

  _Game({
    required this.id,
    required this.name,
    required this.page,
  });
}
