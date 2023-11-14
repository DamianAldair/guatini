import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/game_models.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/util_data.dart';
import 'package:guatini/widgets/media_widgets.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Game1Page extends StatelessWidget {
  final int gameId;

  const Game1Page(this.gameId, {super.key});

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 150);
    final prefs = UserPreferences();

    final counterNotif = ValueNotifier<int>(0);
    final respNotif = ValueNotifier<String?>(null);
    final attemptsNotif = ValueNotifier<int>(0);
    final hitsNotif = ValueNotifier<int>(0);
    int hitsInARow = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).game),
        actions: [
          ValueListenableBuilder(
            valueListenable: counterNotif,
            builder: (_, int counter, ___) => ValueListenableBuilder(
              valueListenable: hitsNotif,
              builder: (_, int hits, ___) {
                return ValueListenableBuilder(
                  valueListenable: attemptsNotif,
                  builder: (_, int attempts, ___) {
                    return Center(
                      child: Text(
                        '${AppLocalizations.of(context).correct}: $hits ${AppLocalizations.of(context).ofde} $attempts   ',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: DbProvider.database,
        builder: (_, AsyncSnapshot<Database?> snapshot) {
          final phError = Center(child: Text(AppLocalizations.of(context).noDatabases));
          const phLoad = Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return phError;
          if (!snapshot.hasData) return phLoad;
          final db = snapshot.data!;
          return FutureBuilder(
            future: SearchProvider.getGameOptions(db, MediaType.image),
            builder: (_, AsyncSnapshot<List<List<dynamic>>> snapshot) {
              if (snapshot.hasError) return phError;
              if (!snapshot.hasData) return phLoad;
              final species = snapshot.data![0] as List<SpeciesModel>;
              final mediaPaths = snapshot.data![1] as List<String>;
              return ValueListenableBuilder(
                valueListenable: counterNotif,
                builder: (_, int counter, ___) {
                  if (counter == species.length) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context).gameOver,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ValueListenableBuilder(
                            valueListenable: hitsNotif,
                            builder: (_, int hits, ___) {
                              return ValueListenableBuilder(
                                valueListenable: attemptsNotif,
                                builder: (_, int attempts, ___) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 20.0,
                                    ),
                                    child: Text(
                                      '${AppLocalizations.of(context).correct}: $hits ${AppLocalizations.of(context).ofde} $attempts   ',
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          ElevatedButton(
                            child: Text(AppLocalizations.of(context).goBack),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                  final optionIndexes = [counter, ...get3RandomIndexes(counter, species.length)]..shuffle();
                  final image = File(p.join(prefs.dbPathNotifier.value!, mediaPaths[counter]).replaceAll('\\', '/'));
                  return ValueListenableBuilder(
                    valueListenable: respNotif,
                    builder: (_, String? resp, ___) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).gameSelectSNameFromCName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          const SizedBox(height: 30.0),
                          Flexible(
                            child: AnimatedSize(
                              duration: duration,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: !image.existsSync()
                                    ? Image.asset('assets/images/image_not_available.png')
                                    : Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.file(image),
                                          IconButton.filledTonal(
                                            icon: const Icon(Icons.fullscreen_rounded),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ImageViewer(
                                                  showInfo: false,
                                                  MediaModel(
                                                    id: 0,
                                                    path: image.path,
                                                    dateCapture: DateTime.now(),
                                                    latitude: 0,
                                                    longitude: 0,
                                                  )..type = const MediaTypeModel(id: 0, type: MediaType.image),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 5.0,
                            ),
                            child: Text(
                              species[counter].searchName ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: duration,
                            child: resp == null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: List.generate(optionIndexes.length, (i) {
                                      final option = species[optionIndexes[i]];
                                      return OutlinedButton(
                                        child: Text(
                                          option.scientificName ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onPressed: () {
                                          if (optionIndexes[i] == counter) {
                                            hitsNotif.value++;
                                            hitsInARow++;
                                          } else {
                                            hitsInARow = 0;
                                          }
                                          attemptsNotif.value++;
                                          if (prefs.games.firstWhere((g) => g.id == gameId).record < hitsInARow) {
                                            prefs.updateGame(GameModel(id: gameId, record: hitsInARow));
                                          }
                                          respNotif.value = option.scientificName;
                                        },
                                      );
                                    }),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            resp == species[counter].scientificName
                                                ? Icons.check_circle_rounded
                                                : Icons.cancel_rounded,
                                            color: resp == species[counter].scientificName ? Colors.green : Colors.red,
                                          ),
                                          const SizedBox.square(dimension: 5.0),
                                          Text(
                                            resp == species[counter].scientificName
                                                ? AppLocalizations.of(context).correct
                                                : AppLocalizations.of(context).incorrect,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color:
                                                  resp == species[counter].scientificName ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15.0),
                                      if (resp != species[counter].scientificName)
                                        Text(
                                          '${AppLocalizations.of(context).itIsNot} $resp.',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                      Text(
                                        '${AppLocalizations.of(context).itIs} ${species[counter].scientificName}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: resp == species[counter].scientificName ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                        child: Text(
                                          AppLocalizations.of(context).next,
                                        ),
                                        onPressed: () {
                                          respNotif.value = null;
                                          counterNotif.value++;
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
