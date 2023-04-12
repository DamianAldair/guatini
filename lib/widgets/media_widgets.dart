import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/media_info_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
          tag: species.id.toString(),
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
              MaterialPageRoute(
                  builder: (_) => ImageViewer(
                        media,
                        speciesId: species.id.toString(),
                      )),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VideoViewer(gallery[i])),
                        );
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
        return Stack(
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
              child: const Icon(Icons.play_arrow_rounded),
            ),
          ],
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
  final Object? speciesId;

  ImageViewer(
    this.media, {
    Key? key,
    this.speciesId,
  })  : assert(media.mediaType.type == MediaType.image),
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
              heroAttributes:
                  PhotoViewHeroAttributes(tag: widget.speciesId.toString()),
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

class _GalleryViewerState extends State<GalleryViewer>
    with SingleTickerProviderStateMixin {
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
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 33.0),
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
                              final media = list[pageController.page!.round()];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MediaInfoPage(
                                          media,
                                          heroTag: media.id.toString(),
                                        )),
                              );
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

StreamController mediaStream = StreamController.broadcast();

class AudioCard extends StatelessWidget {
  final List<MediaModel>? medias;

  const AudioCard(this.medias, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MediaModel> list = [];
    if (medias != null) {
      for (MediaModel m in medias!) {
        if (m.mediaType.type != null && m.mediaType.type! == MediaType.audio) {
          list.add(m);
        }
      }
    }

    const radius = 10.0;

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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                      '${AppLocalizations.of(context).sound}${list.length == 1 ? '' : 's'}'),
                ),
                for (MediaModel sound in list) _AudioItem(sound),
              ],
            ),
          );
  }
}

class _AudioItem extends StatefulWidget {
  final MediaModel sound;

  const _AudioItem(this.sound, {Key? key}) : super(key: key);

  @override
  State<_AudioItem> createState() => __AudioItemState();
}

class __AudioItemState extends State<_AudioItem>
    with SingleTickerProviderStateMixin {
  late Key key;
  late AnimationController animationController;
  late AudioPlayer player;
  bool isPlaying = false;
  bool playable = false;
  Duration position = const Duration();
  Duration duration = const Duration();

  @override
  void initState() {
    key = Key(widget.sound.id.toString());
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    player = AudioPlayer(playerId: key.toString());
    player.setSource(UrlSource(_audioPath));
    player.onPositionChanged.listen((p) => setState(() => position = p));
    player.onDurationChanged.listen((d) => setState(() => duration = d));
    player.onPlayerComplete.listen((_) {
      animationController.reverse();
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // mediaStream.stream.listen((event) {
    //   if (event != key) pause();
    // });
    super.didChangeDependencies();
  }

  String get _audioPath {
    final prefs = UserPreferences();
    final path = p.join(prefs.dbPath, widget.sound.path);
    playable = File(path).existsSync();
    return path;
  }

  void play() {
    if (playable) {
      mediaStream.add(key);
      animationController.forward();
      isPlaying = true;
      // player.play(UrlSource(_audioPath));
      player.resume();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('text'),
        ),
      );
    }
  }

  void pause() {
    animationController.reverse();
    isPlaying = false;
    player.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: animationController,
            ),
            onPressed: isPlaying ? pause : play,
          ),
          Expanded(
            child: Column(
              children: [
                Slider(
                  value: position.inMilliseconds.toDouble(),
                  max: duration.inMilliseconds.toDouble(),
                  onChanged: (value) => setState(() {
                    final d = Duration(milliseconds: value.toInt());
                    player.seek(d);
                    position = d;
                  }),
                ),
                Row(
                  children: [
                    const SizedBox(width: 30.0),
                    Text(parseDuration(position)),
                    const Expanded(child: SizedBox()),
                    Text(parseDuration(duration)),
                    const SizedBox(width: 30.0),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class VideoViewer extends StatefulWidget {
  final MediaModel media;

  const VideoViewer(this.media, {Key? key}) : super(key: key);

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late VideoPlayerController video;
  bool showAppBar = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    final path = p.join(UserPreferences().dbPath, widget.media.path);
    video = VideoPlayerController.file(File(path));
    video.addListener(() => setState(() {}));
    video.initialize().then((value) => setState(() {}));
    video.setLooping(false);
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
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 33.0),
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
                                  IconButton(
                                    icon: const Icon(Icons.info_outlined),
                                    color: Colors.white,
                                    tooltip: AppLocalizations.of(context).info,
                                    onPressed: () async {
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
                                          video.value.position
                                              .toString()
                                              .split('.')[0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          max: video
                                              .value.duration.inMilliseconds
                                              .toDouble(),
                                          value: video
                                              .value.position.inMilliseconds
                                              .toDouble(),
                                          onChanged: (value) {
                                            video.seekTo(Duration(
                                                milliseconds: value.toInt()));
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          video.value.duration
                                              .toString()
                                              .split('.')[0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(child: SizedBox()),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.skip_previous_rounded),
                                        color: Colors.white,
                                        tooltip:
                                            AppLocalizations.of(context).replay,
                                        onPressed: () {
                                          setState(() {
                                            video.seekTo(
                                                const Duration(seconds: 0));
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
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        height: 50.0,
                                        width: 50.0,
                                        child: IconButton(
                                          icon: Icon(video.value.isPlaying
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded),
                                          color: Colors.black,
                                          tooltip: video.value.isPlaying
                                              ? AppLocalizations.of(context)
                                                  .pause
                                              : AppLocalizations.of(context)
                                                  .play,
                                          onPressed: () {
                                            setState(() {
                                              video.value.isPlaying
                                                  ? video.pause()
                                                  : video.play();
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      IconButton(
                                        icon: const Icon(Icons.stop_rounded),
                                        color: Colors.white,
                                        tooltip:
                                            AppLocalizations.of(context).stop,
                                        onPressed: () {
                                          setState(() {
                                            video.seekTo(
                                                const Duration(seconds: 0));
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
