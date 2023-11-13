import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/media_info_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

class MainImage extends StatelessWidget {
  final SpeciesModel species;

  const MainImage(this.species, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final db = prefs.dbPathNotifier.value!;
    final mainImage = species.mainImage
      ?..mediaType = const MediaTypeModel(
        id: null,
        type: MediaType.image,
      );
    if (mainImage == null) return const SizedBox.shrink();
    final file = File(p.join(db, mainImage.path).replaceAll('\\', '/'));
    if (!file.existsSync()) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        child: Hero(
          tag: species.id.toString(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () {
          final media = species.mainImage;
          if (media != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageViewer(
                  media,
                  speciesId: species.id.toString(),
                ),
              ),
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
    if (medias == null) return const SizedBox.shrink();
    final prefs = UserPreferences();
    List<MediaModel> gallery = [];
    for (MediaModel m in medias!) {
      if (m.mediaType.type != MediaType.audio) {
        if (mainImageId == null || m.id != mainImageId) {
          if (m.isOffline ||
              (m.mediaType.type == MediaType.image && prefs.imageOnline) ||
              (m.mediaType.type == MediaType.video && prefs.videoOnline)) {
            gallery.add(m);
          }
        }
      }
    }
    if (gallery.isEmpty) return const SizedBox.shrink();
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
                      UserPreferences().dbPathNotifier.value!,
                      gallery[i].path?.replaceAll('\\', '/'),
                    );
                    final file = File(path);
                    if (gallery[i].isOnline || file.existsSync()) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VideoViewer(gallery[i])),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context).errorObtainingInfo),
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
    final placeholder = Image.asset(
      'assets/images/image_not_available.png',
      fit: BoxFit.cover,
    );
    if (media.path == null) return placeholder;
    if (media.isOffline) {
      final path = p.join(UserPreferences().dbPathNotifier.value!, media.path).replaceAll('\\', '/');
      final file = File(path);
      if (media.mediaType.type == MediaType.image) {
        return !file.existsSync()
            ? placeholder
            : Image.file(
                file,
                fit: BoxFit.cover,
              );
      } else if (media.mediaType.type == MediaType.video) {
        return !file.existsSync()
            ? placeholder
            : Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  FutureBuilder(
                    future: VideoThumbnail.thumbnailData(video: path),
                    builder: (_, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
      }
    } else {
      if (media.mediaType.type == MediaType.image) {
        return FutureBuilder(
          future: http.get(Uri.parse(media.path!)),
          builder: (_, AsyncSnapshot<http.Response> snapshot) {
            const ph = Icon(Icons.broken_image_rounded);
            final Widget child;
            if (snapshot.hasError) {
              child = ph;
            } else if (snapshot.connectionState != ConnectionState.done ||
                (snapshot.connectionState == ConnectionState.done && !snapshot.hasData)) {
              child = const CircularProgressIndicator();
            } else {
              child = Image.memory(
                snapshot.data!.bodyBytes,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => ph,
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(color: Colors.grey.withOpacity(0.3)),
                child,
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.language_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else if (media.mediaType.type == MediaType.video) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(color: Colors.grey.withOpacity(0.3)),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.ondemand_video_rounded),
              ),
            ),
            Container(
              width: 45.0,
              height: 45.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
            ),
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.language_rounded),
              ),
            ),
          ],
        );
      }
    }
    return placeholder;
  }
}

class ImageViewer extends StatefulWidget {
  final MediaModel media;
  final Object? speciesId;
  final bool showInfo;

  ImageViewer(
    this.media, {
    Key? key,
    this.speciesId,
    this.showInfo = true,
  })  : assert(media.mediaType.type == MediaType.image),
        super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with SingleTickerProviderStateMixin {
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
    final path = p.join(UserPreferences().dbPathNotifier.value!, widget.media.path);
    final imageProvider = FileImage(File(path));
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: PhotoView(
              heroAttributes: PhotoViewHeroAttributes(tag: widget.speciesId.toString()),
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
                              padding: const EdgeInsets.only(left: 15.0, right: 33.0),
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
                            if (widget.showInfo)
                              IconButton(
                                icon: const Icon(Icons.info_outlined),
                                color: Colors.white,
                                tooltip: AppLocalizations.of(context).info,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MediaInfoPage(
                                      widget.media,
                                      heroTag: widget.speciesId,
                                    ),
                                  ),
                                ),
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

class _GalleryViewerState extends State<GalleryViewer> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  List<MediaModel> list = [];
  late PageController pageController;
  bool showAppBar = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
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
    pageController = PageController(initialPage: page);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: PhotoViewGallery.builder(
              itemCount: list.length,
              pageController: pageController,
              builder: (_, int i) {
                final media = list[i];
                final imageProvider = media.isOffline
                    ? FileImage(
                        File(p
                            .join(
                              UserPreferences().dbPathNotifier.value!,
                              media.path,
                            )
                            .replaceAll('\\', '/')),
                      )
                    : NetworkImage(media.path!) as ImageProvider;
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
            builder: (_, __) => showAppBar
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
                            padding: const EdgeInsets.only(left: 15.0, right: 33.0),
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
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.info_outlined),
                            color: Colors.white,
                            tooltip: AppLocalizations.of(context).info,
                            onPressed: () {
                              final media = list[pageController.page!.round()];
                              if (media.isOnline) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(media.path ?? AppLocalizations.of(context).errorObtainingInfo),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MediaInfoPage(
                                      media,
                                      heroTag: media.id.toString(),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class AudioCard extends StatelessWidget {
  final List<MediaModel>? medias;

  const AudioCard(this.medias, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;

    List<MediaModel> list = [];
    if (medias != null) {
      for (MediaModel m in medias!) {
        if (m.mediaType.type != null && m.mediaType.type! == MediaType.audio) {
          if (m.isOffline) {
            list.add(m);
          } else if (UserPreferences().audioOnline) {
            list.add(m);
          }
        }
      }
    }
    return list.isEmpty
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 7.0,
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(radius),
            ),
            width: double.infinity,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: list.length.clamp(1, 2),
                childAspectRatio: list.length == 1 ? 3.0 : 1.0,
              ),
              itemCount: list.length,
              itemBuilder: (_, int i) {
                final title = list.length == 1
                    ? AppLocalizations.of(context).sound
                    : '${AppLocalizations.of(context).sound} ${i + 1}';
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5.0),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        showDragHandle: true,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        builder: (_) => AudioViewer(
                          list[i],
                          title: title,
                        ),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Icon(
                              Icons.audiotrack_rounded,
                              size: 35.0,
                            ),
                          ),
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class AudioViewer extends StatefulWidget {
  final MediaModel media;
  final String? title;
  final bool showInfo;

  const AudioViewer(
    this.media, {
    Key? key,
    this.title,
    this.showInfo = true,
  }) : super(key: key);

  @override
  State<AudioViewer> createState() => _AudioViewerState();
}

class _AudioViewerState extends State<AudioViewer> {
  final prefs = UserPreferences();
  late VideoPlayerController audio;

  @override
  void initState() {
    if (widget.media.isOffline) {
      final path = p.join(prefs.dbPathNotifier.value!, widget.media.path).replaceAll('\\', '/');
      audio = VideoPlayerController.file(File(path));
    } else {
      audio = VideoPlayerController.network(widget.media.path!);
    }
    audio.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    audio.setLooping(false);
    audio.initialize().then((_) => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prefs.autoplayVideo) {
        audio.play();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showInfo)
          Row(
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.info_outlined),
                tooltip: AppLocalizations.of(context).info,
                onPressed: () async {
                  if (widget.media.isOnline) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(AppLocalizations.of(context).link),
                        content: Text(
                          widget.media.path ?? AppLocalizations.of(context).errorObtainingInfo,
                        ),
                        actions: [
                          TextButton(
                            child: Text(AppLocalizations.of(context).ok),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (audio.value.isPlaying) {
                      await audio.pause();
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MediaInfoPage(widget.media),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        if (portrait)
          Icon(
            Icons.audiotrack_rounded,
            size: MediaQuery.of(context).size.width / 4,
          ),
        Text(widget.title ?? AppLocalizations.of(context).sound),
        const SizedBox(height: 20.0),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(parseDuration(audio.value.position)),
            ),
            Expanded(
              child: VideoProgressIndicator(
                audio,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: theme.iconTheme.color!,
                  bufferedColor: theme.iconTheme.color!.withOpacity(0.25),
                  backgroundColor: theme.iconTheme.color!.withOpacity(0.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(parseDuration(audio.value.duration)),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              tooltip: AppLocalizations.of(context).replay,
              onPressed: () async {
                await audio.seekTo(Duration.zero);
                await audio.play();
                setState(() {});
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: theme.iconTheme.color,
                borderRadius: BorderRadius.circular(100.0),
              ),
              height: 50.0,
              width: 50.0,
              child: IconButton(
                icon: Icon(
                  audio.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                color: theme.colorScheme.background,
                tooltip: audio.value.isPlaying ? AppLocalizations.of(context).pause : AppLocalizations.of(context).play,
                onPressed: () async {
                  audio.value.isPlaying ? await audio.pause() : await audio.play();
                  setState(() {});
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.stop_rounded),
              tooltip: AppLocalizations.of(context).stop,
              onPressed: () async {
                await audio.seekTo(Duration.zero);
                await audio.pause();
                setState(() {});
              },
            ),
          ],
        ),
        SizedBox(height: portrait ? 40.0 : 10.0),
      ],
    );
  }
}

class VideoViewer extends StatefulWidget {
  final MediaModel media;
  final bool showInfo;

  const VideoViewer(
    this.media, {
    Key? key,
    this.showInfo = true,
  }) : super(key: key);

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> with SingleTickerProviderStateMixin {
  final prefs = UserPreferences();
  late AnimationController controller;
  late VideoPlayerController video;
  bool showAppBar = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    if (widget.media.isOffline) {
      final path = p.join(prefs.dbPathNotifier.value!, widget.media.path).replaceAll('\\', '/');
      video = VideoPlayerController.file(File(path));
    } else {
      video = VideoPlayerController.network(widget.media.path!);
    }
    video.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    video.setLooping(false);
    video.initialize().then((_) => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prefs.autoplayVideo) {
        video.play();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    video.dispose();
    enabledSystemUIMode();
    super.dispose();
  }

  Future<void> enabledSystemUIMode() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    final paddingTop = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async {
        await enabledSystemUIMode();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              child: Center(
                child: Hero(
                  tag: widget.media.id.toString(),
                  child: AspectRatio(
                    aspectRatio: video.value.aspectRatio,
                    child: VideoPlayer(video),
                  ),
                ),
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
                        child: Column(
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              height: kToolbarHeight + paddingTop,
                              padding: EdgeInsets.only(top: paddingTop),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    color: Colors.white,
                                    padding: const EdgeInsets.only(left: 15.0, right: 33.0),
                                    tooltip: AppLocalizations.of(context).back,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).video,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  if (widget.showInfo)
                                    IconButton(
                                      icon: const Icon(Icons.info_outlined),
                                      color: Colors.white,
                                      tooltip: AppLocalizations.of(context).info,
                                      onPressed: () async {
                                        if (widget.media.isOnline) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                widget.media.path ?? AppLocalizations.of(context).errorObtainingInfo,
                                              ),
                                            ),
                                          );
                                        } else {
                                          if (video.value.isPlaying) {
                                            await video.pause();
                                          }
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MediaInfoPage(
                                                widget.media,
                                                heroTag: widget.media.id.toString(),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          video.value.position.toString().split('.')[0],
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        child: VideoProgressIndicator(
                                          video,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor: Colors.white,
                                            bufferedColor: Colors.white.withOpacity(0.4),
                                            backgroundColor: Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          video.value.duration.toString().split('.')[0],
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(child: SizedBox()),
                                      IconButton(
                                        icon: const Icon(Icons.skip_previous_rounded),
                                        color: Colors.white,
                                        tooltip: AppLocalizations.of(context).replay,
                                        onPressed: () {
                                          setState(() {
                                            video.seekTo(const Duration(seconds: 0));
                                            if (!video.value.isPlaying) {
                                              video.play();
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 20.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(100.0),
                                        ),
                                        height: 50.0,
                                        width: 50.0,
                                        child: IconButton(
                                          icon: Icon(
                                              video.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                                          color: Colors.black,
                                          tooltip: video.value.isPlaying
                                              ? AppLocalizations.of(context).pause
                                              : AppLocalizations.of(context).play,
                                          onPressed: () async {
                                            video.value.isPlaying ? await video.pause() : await video.play();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      IconButton(
                                        icon: const Icon(Icons.stop_rounded),
                                        color: Colors.white,
                                        tooltip: AppLocalizations.of(context).stop,
                                        onPressed: () {
                                          setState(() {
                                            video.seekTo(const Duration(seconds: 0));
                                            if (video.value.isPlaying) {
                                              video.pause();
                                            }
                                          });
                                        },
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                  const SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
