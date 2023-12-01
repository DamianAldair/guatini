import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/media_widgets.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class MoreMedia extends StatelessWidget {
  final int? authorId;
  final int? licenseId;

  const MoreMedia({
    Key? key,
    this.authorId,
    this.licenseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (authorId == null && licenseId == null) {
      return const SizedBox.shrink();
    }
    return FutureBuilder(
      future: DbProvider.database,
      builder: (_, AsyncSnapshot<Database?> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final db = snapshot.data as Database;
        return FutureBuilder(
          future: SearchProvider.moreMedia(
            db,
            authorId: authorId,
            licenseId: licenseId,
          ),
          builder: (_, AsyncSnapshot<List<MediaModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final medias = snapshot.data;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: medias!.length,
              itemBuilder: (_, int i) {
                final db = UserPreferences().dbPathNotifier.value!;
                final path = p.join(File(db).parent.path, medias[i].path).replaceAll('\\', '/');
                final file = File(path);
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
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset('assets/images/image_not_available.png'),
                      ),
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
    );
  }
}
