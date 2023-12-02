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

class Game2Page extends StatelessWidget {
  final int gameId;

  const Game2Page(this.gameId, {super.key});

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 150);
    final prefs = UserPreferences();

    final counterNotif = ValueNotifier<int>(0);
    final imagePathNotif = ValueNotifier<String?>(null);
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
              if (species.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      AppLocalizations.of(context).noEnoughDbInfo,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
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
                  final optionIndexes = [counter, ...get3RandomIndexes(counter, mediaPaths.length)]..shuffle();
                  final correctSpecies = species[counter];
                  return ValueListenableBuilder(
                    valueListenable: imagePathNotif,
                    builder: (_, String? imagePath, ___) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).gameSelectImageFromCName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          const SizedBox(height: 30.0),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  correctSpecies.searchName ?? '',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(correctSpecies.scientificName ?? ''),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: duration,
                            child: imagePath == null
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                    itemCount: optionIndexes.length,
                                    itemBuilder: (_, int i) {
                                      final option = mediaPaths[optionIndexes[i]];
                                      final db = prefs.dbPathNotifier.value!;
                                      final image = File(p.join(File(db).parent.path, option).replaceAll('\\', '/'));
                                      return AnimatedSize(
                                        duration: duration,
                                        child: Card(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: !image.existsSync()
                                                ? Image.asset('assets/images/image_not_available.png')
                                                : Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        child: Image.file(
                                                          image,
                                                          errorBuilder: (_, __, ___) =>
                                                              Image.asset('assets/images/image_not_available.png'),
                                                        ),
                                                        onTap: () {
                                                          if (optionIndexes[i] == counter) {
                                                            hitsNotif.value++;
                                                            hitsInARow++;
                                                          } else {
                                                            hitsInARow = 0;
                                                          }
                                                          attemptsNotif.value++;
                                                          if (prefs.games.firstWhere((g) => g.id == gameId).record <
                                                              hitsInARow) {
                                                            prefs.updateGame(GameModel(id: gameId, record: hitsInARow));
                                                          }
                                                          imagePathNotif.value = option;
                                                        },
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: IconButton.filledTonal(
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
                                                                )..type =
                                                                    const MediaTypeModel(id: 0, type: MediaType.image),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            imagePath == mediaPaths[counter]
                                                ? Icons.check_circle_rounded
                                                : Icons.cancel_rounded,
                                            color: imagePath == mediaPaths[counter] ? Colors.green : Colors.red,
                                          ),
                                          const SizedBox.square(dimension: 5.0),
                                          Text(
                                            imagePath == mediaPaths[counter]
                                                ? AppLocalizations.of(context).correct
                                                : AppLocalizations.of(context).incorrect,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: imagePath == mediaPaths[counter] ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      if (imagePath != mediaPaths[counter])
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text(AppLocalizations.of(context).correctAnswerIs),
                                        ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          child: FutureBuilder(
                                            future: File(p
                                                    .join(File(prefs.dbPathNotifier.value!).parent.path,
                                                        mediaPaths[counter])
                                                    .replaceAll('\\', '/'))
                                                .exists(),
                                            builder: (_, AsyncSnapshot<bool> snapshot) {
                                              const phError = Center(child: Icon(Icons.broken_image_rounded));
                                              const phLoad = Center(child: CircularProgressIndicator());
                                              if (snapshot.hasError) return phError;
                                              if (!snapshot.hasData) return phLoad;
                                              return !snapshot.data!
                                                  ? Image.asset('assets/images/image_not_available.png')
                                                  : Image.file(
                                                      File(p
                                                          .join(File(prefs.dbPathNotifier.value!).parent.path,
                                                              mediaPaths[counter])
                                                          .replaceAll('\\', '/')),
                                                      errorBuilder: (_, __, ___) => phError,
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                        child: Text(
                                          AppLocalizations.of(context).next,
                                        ),
                                        onPressed: () {
                                          imagePathNotif.value = null;
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
