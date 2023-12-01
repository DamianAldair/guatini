import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/license_model.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/pages/map_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/info_card_widget.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaInfoPage extends StatelessWidget {
  final MediaModel media;
  final Object? heroTag;

  const MediaInfoPage(
    this.media, {
    this.heroTag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = UserPreferences().dbPathNotifier.value!;
    final path = p.join(File(db).parent.path, media.path).replaceAll('\\', '/');
    final file = File(path);
    final size = MediaQuery.of(context).size.width / 3;

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
                  media.authorId == null
                      ? Future.value(<AuthorModel>[])
                      : SearchProvider.getAuthors(db, media.authorId!),
                  media.licenseId == null ? Future.value(null) : SearchProvider.getLicense(db, media.licenseId!),
                ]),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final results = snapshot.data as List;
                  final authors = results[0] as List<AuthorModel>;
                  final license = results[1] as LicenseModel?;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: media.mediaType.type != MediaType.audio
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(media.mediaType.type != MediaType.audio ? 20.0 : 0.0),
                              child: Hero(
                                tag: heroTag.toString(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: SizedBox(
                                    height: size,
                                    width: media.mediaType.type != MediaType.audio ? size : 0.0,
                                    child: FutureBuilder(
                                      future: file.exists(),
                                      builder: (_, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (media.mediaType.type == MediaType.image) {
                                          return snapshot.data
                                              ? Image.file(
                                                  file,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/images/image_not_available.png',
                                                  fit: BoxFit.cover,
                                                );
                                        } else if (media.mediaType.type == MediaType.video) {
                                          return FutureBuilder(
                                            future: VideoThumbnail.thumbnailData(video: path),
                                            builder: (_, AsyncSnapshot snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    color: Colors.black.withOpacity(0.6),
                                                  ),
                                                  Image.memory(
                                                    snapshot.data,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Container(
                                                    width: 45.0,
                                                    height: 45.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(100.0),
                                                    ),
                                                    child: const Icon(Icons.play_arrow_rounded),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
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
                            AppLocalizations.of(context).date(media.dateCapture!),
                            style: const TextStyle(fontSize: 17.0),
                          ),
                        ),
                        AuthorCard(authors, media.mediaType.type!),
                        LicenseCard(license),
                        if (media.latitude != null && media.longitude != null)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.location_pin),
                              label: Text(
                                AppLocalizations.of(context).seeMediaLocation,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MapPage(
                                    location: MapLatLng(media.latitude!, media.longitude!),
                                    customTitle: AppLocalizations.of(context).seeMediaLocation,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
