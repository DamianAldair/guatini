import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/license_model.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/info_card_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class MediaInfoPage extends StatelessWidget {
  final MediaModel media;
  final Object? heroTag;

  const MediaInfoPage(this.media, {this.heroTag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final path = p.join(UserPreferences().dbPath, media.path);
    final file = File(path);
    final image = file.existsSync()
        ? Image.file(
            file,
            fit: BoxFit.cover,
          )
        : Image.asset(
            'assets/images/image_not_available.png',
            fit: BoxFit.cover,
          );
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).info),
      ),
      body: FutureBuilder(
          future: DbProvider.database,
          builder: (_, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final db = snapshot.data as Database;
            return FutureBuilder(
                future: Future.wait([
                  SearchProvider.getAuthor(db, media.authorId!),
                  SearchProvider.getLicense(db, media.licenseId!),
                ]),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final results = snapshot.data as List;
                  final author = results[0] as AuthorModel;
                  final license = results[1] as LicenseModel;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Hero(
                                tag: heroTag.toString(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: SizedBox(
                                    height: size.width / 3,
                                    width: size.width / 3,
                                    child: image,
                                  ),
                                ),
                              ),
                            ),
                            mediaType(context, media.mediaType.type),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 15.0,
                          ),
                          child: Text(
                            AppLocalizations.of(context).date(media.date!),
                            style: const TextStyle(fontSize: 17.0),
                          ),
                        ),
                        AuthorCard(author),
                        LicenseCard(license),
                        //TODO: map with capture location
                      ],
                    ),
                  );
                });
          }),
    );
  }

  Widget mediaType(BuildContext context, MediaType? type) {
    final IconData icon;
    final String name;
    switch (type) {
      case MediaType.audio:
        icon = Icons.audiotrack_rounded;
        name = AppLocalizations.of(context).audio;
        break;
      case MediaType.image:
        icon = Icons.image_rounded;
        name = AppLocalizations.of(context).image;
        break;
      case MediaType.video:
        icon = Icons.videocam_rounded;
        name = AppLocalizations.of(context).video;
        break;
      default:
        icon = Icons.not_interested_rounded;
        name = AppLocalizations.of(context).unknown;
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Icon(icon, size: 40.0),
        ),
        Text(name, style: const TextStyle(fontSize: 25.0)),
      ],
    );
  }
}
