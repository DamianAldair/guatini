import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/media_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:selectable/selectable.dart';
import 'package:sqflite/sqflite.dart';

class AuthorDetailsPage extends StatelessWidget {
  final AuthorModel? author;

  const AuthorDetailsPage(this.author, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final dbPath = prefs.dbPath;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).author),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_rounded,
              size: 80.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                author?.name ?? AppLocalizations.of(context).unknown,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Selectable(
              popupMenuItems: [
                SelectableMenuItem(type: SelectableMenuItemType.copy),
              ],
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  author?.description ?? AppLocalizations.of(context).unknown,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                '${AppLocalizations.of(context).moreOf} ${author?.name ?? AppLocalizations.of(context).unknown}',
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder(
              future: DbProvider.database,
              builder: (_, AsyncSnapshot<Database?> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final db = snapshot.data as Database;
                return FutureBuilder(
                  future: SearchProvider.moreMedia(db, authorId: author!.id),
                  builder: (_, AsyncSnapshot<List<MediaModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final medias = snapshot.data;
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemCount: medias!.length,
                      itemBuilder: (_, int i) {
                        final file = File(p.join(dbPath, medias[i].path));
                        if (!file.existsSync()) {
                          return Image.asset(
                            'assets/images/image_not_available.png',
                            fit: BoxFit.cover,
                          );
                        }
                        final media = medias[i];
                        switch (media.type!.type) {
                          case MediaType.audio:
                            return GestureDetector(
                              child: Container(
                                color: Colors.grey.withOpacity(0.5),
                                child: const Icon(
                                  Icons.audiotrack_rounded,
                                  size: 50.0,
                                ),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0),
                                    ),
                                  ),
                                  builder: (_) => AudioViewer(
                                    media,
                                    showInfo: false,
                                  ),
                                );
                              },
                            );
                          case MediaType.image:
                            return GestureDetector(
                              child: Image.file(file, fit: BoxFit.cover),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ImageViewer(
                                          media,
                                          speciesId: media.speciesId,
                                          showInfo: false,
                                        )),
                              ),
                            );
                          case MediaType.video:
                            return GestureDetector(
                              child: Thumbnail(media),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VideoViewer(
                                          media,
                                          showInfo: false,
                                        )),
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
