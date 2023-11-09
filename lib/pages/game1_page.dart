import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/game_models.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/media_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Game1Page extends StatefulWidget {
  const Game1Page({Key? key}) : super(key: key);

  @override
  State<Game1Page> createState() => _Game1PageState();
}

class _Game1PageState extends State<Game1Page> {
  String resp = '';
  bool correct = false;
  List<Game1Option>? options;
  Game1Option? correctOption;
  int attempts = 0;
  int hits = 0;
  int hitsInARow = 0;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 150);
    final prefs = UserPreferences();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).game),
        actions: [
          Center(
              child: Text(
                  '${AppLocalizations.of(context).correct}: $hits ${AppLocalizations.of(context).ofde} $attempts   ')),
        ],
      ),
      body: FutureBuilder(
        future: DbProvider.database,
        builder: (_, AsyncSnapshot<Database?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context).noDatabases));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final db = snapshot.data!;
          return FutureBuilder(
            future: SearchProvider.getGame1Options(db),
            builder: (_, AsyncSnapshot<List<Game1Option>> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(AppLocalizations.of(context).noDatabases));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              options ??= snapshot.data!;
              final correctIndex = Random().nextInt(options!.length - 1);
              correctOption ??= options![correctIndex];
              final image = File(p.join(prefs.dbPathNotifier.value!, correctOption!.imagePath));
              return Padding(
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
                          child: image.existsSync()
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
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
                                    );
                                  },
                                  child: Image.file(image),
                                )
                              : Image.asset('assets/images/image_not_available.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 5.0,
                      ),
                      child: Text(
                        correctOption!.commonName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: duration,
                      child: resp.isEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: options!.length,
                              itemBuilder: (_, int i) {
                                return ElevatedButton(
                                  child: Text(options![i].scientificName),
                                  onPressed: () {
                                    setState(() {
                                      resp = options![i].scientificName;
                                      correct = resp == correctOption!.scientificName;
                                      if (correct) {
                                        hits++;
                                        hitsInARow++;
                                      } else {
                                        hitsInARow = 0;
                                      }
                                      attempts++;
                                      if (prefs.games.where((e) => e.id == 1).first.record < hitsInARow) {
                                        prefs.updateGame(GameModel(id: 1, record: hitsInARow));
                                      }
                                    });
                                  },
                                );
                              },
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  correct
                                      ? AppLocalizations.of(context).correct
                                      : AppLocalizations.of(context).incorrect,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                                const SizedBox(height: 15.0),
                                if (!correct)
                                  Text(
                                    '${AppLocalizations.of(context).itIsNot} $resp',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                Text(
                                  '${AppLocalizations.of(context).itIs} ${correctOption!.scientificName}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  child: Text(
                                    AppLocalizations.of(context).next,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      correct = false;
                                      resp = '';
                                      options = null;
                                      correctOption = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
