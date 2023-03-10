import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MainImage extends StatelessWidget {
  final SpeciesModel species;

  const MainImage(this.species, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final db = prefs.dbPath;
    final mainImage = species.mainImage
      ?..mediaType = const MediaTypeModel(
        id: null,
        type: MediaType.image,
      );
    Image? image;
    if (mainImage != null) {
      final file = File(p.join(db, mainImage.path));
      if (file.existsSync()) {
        image = Image.file(
          file,
          fit: BoxFit.cover,
        );
      }
    }
    image ??= Image.asset(
      'assets/images/image_not_available.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        child: Hero(
          tag: 'mainImage',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: image,
          ),
        ),
        onTap: () {
          final media = species.mainImage;
          if (media != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ImageViewer(media)),
            );
          }
        },
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  final List<MediaModel>? medias;
  final int? mainImageId;

  Gallery(
    this.medias, {
    Key? key,
    this.mainImageId,
  }) : super(key: key);

  final galleryStreamController = StreamController();

  @override
  Widget build(BuildContext context) {
    if (medias == null) return Container();
    List<MediaModel> gallery = [];
    for (MediaModel m in medias!) {
      if (m.mediaType.type != MediaType.audio) {
        if (mainImageId == null) {
          gallery.add(m);
        } else if (m.id != mainImageId) {
          gallery.add(m);
        }
      }
    }
    if (gallery.isEmpty) return Container();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            bottom: 10.0,
          ),
          child: Text(
            AppLocalizations.of(context).gallery,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200.0,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.6),
            pageSnapping: false,
            itemCount: gallery.length,
            itemBuilder: (_, int i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GestureDetector(
                  child: Hero(
                    tag: gallery[i].id!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Thumbnail(gallery[i]),
                    ),
                  ),
                  onTap: () {
                    final path = p.join(
                      UserPreferences().dbPath,
                      gallery[i].path,
                    );
                    final file = File(path);
                    if (file.existsSync()) {
                      if (gallery[i].mediaType.type == MediaType.image) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GalleryViewer(
                              gallery,
                              currentMedia: gallery[i],
                            ),
                          ),
                        );
                      }
                      if (gallery[i].mediaType.type == MediaType.video) {
                        galleryStreamController.add(true);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              AppLocalizations.of(context).errorObtainingInfo),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Thumbnail extends StatelessWidget {
  final MediaModel media;
  const Thumbnail(this.media, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final path = p.join(UserPreferences().dbPath, media.path);
    final file = File(path);
    if (media.mediaType.type == MediaType.image) {
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'assets/images/image_not_available.png',
          fit: BoxFit.cover,
        );
      }
    }
    if (media.mediaType.type == MediaType.video) {
      if (file.existsSync()) {
        //TODO: Use video_thumbnail lib
        return Image.asset(
          'assets/images/video.png',
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'assets/images/video_not_available.png',
          fit: BoxFit.cover,
        );
      }
    }
    return Image.asset(
      'assets/images/image_not_available.png',
      fit: BoxFit.cover,
    );
  }
}

class ImageViewer extends StatefulWidget {
  final MediaModel media;

  ImageViewer(this.media, {Key? key})
      : assert(media.mediaType.type == MediaType.image),
        super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool showAppBar = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = p.join(UserPreferences().dbPath, widget.media.path);
    final imageProvider = FileImage(File(path));
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: PhotoView(
              heroAttributes: const PhotoViewHeroAttributes(tag: 'mainImage'),
              imageProvider: imageProvider,
              minScale: PhotoViewComputedScale.contained,
              maxScale: 10.0,
            ),
            onTap: () {
              if (showAppBar) {
                controller.forward(from: controller.value);
                showAppBar = false;
              } else {
                controller.reverse(from: controller.value);
                showAppBar = true;
              }
            },
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return showAppBar
                  ? Opacity(
                      opacity: 1 - controller.value,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        height: kToolbarHeight + paddingTop,
                        padding: EdgeInsets.only(top: paddingTop),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 33.0),
                              tooltip: AppLocalizations.of(context).back,
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              AppLocalizations.of(context).image,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            IconButton(
                              icon: const Icon(Icons.info_outlined),
                              color: Colors.white,
                              tooltip: AppLocalizations.of(context).info,
                              onPressed: () {
                                //TODO: Image info
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class GalleryViewer extends StatefulWidget {
  final List<MediaModel> medias;
  final MediaModel? currentMedia;

  const GalleryViewer(
    this.medias, {
    Key? key,
    this.currentMedia,
  }) : super(key: key);

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool showAppBar = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MediaModel> list = [];
    for (MediaModel m in widget.medias) {
      if (m.mediaType.type == MediaType.image) {
        list.add(m);
      }
    }
    int page = 0;
    if (widget.currentMedia != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id! == widget.currentMedia!.id!) {
          page = i;
          break;
        }
      }
    }
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: PhotoViewGallery.builder(
              itemCount: list.length,
              pageController: PageController(initialPage: page),
              builder: (_, int i) {
                final media = list[i];
                final path = p.join(UserPreferences().dbPath, media.path);
                final imageProvider = FileImage(File(path));
                return PhotoViewGalleryPageOptions(
                  heroAttributes: PhotoViewHeroAttributes(tag: media.id!),
                  imageProvider: imageProvider,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: 10.0,
                );
              },
            ),
            onTap: () {
              if (showAppBar) {
                controller.forward(from: controller.value);
                showAppBar = false;
              } else {
                controller.reverse(from: controller.value);
                showAppBar = true;
              }
            },
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return showAppBar
                  ? Opacity(
                      opacity: 1 - controller.value,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        height: kToolbarHeight + paddingTop,
                        padding: EdgeInsets.only(top: paddingTop),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 33.0),
                              tooltip: AppLocalizations.of(context).back,
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              AppLocalizations.of(context).image,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            IconButton(
                              icon: const Icon(Icons.info_outlined),
                              color: Colors.white,
                              tooltip: AppLocalizations.of(context).info,
                              onPressed: () {
                                //TODO: Image info
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
