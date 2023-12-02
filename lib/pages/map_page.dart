import 'dart:async';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guatini/pages/nearby_species_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapPage extends StatefulWidget {
  final MapLatLng? location;
  final List<List<MapLatLng>>? polygons;
  final List<String>? descriptiopns;
  final bool search;
  final String? customTitle;

  const MapPage({
    Key? key,
    this.location,
    this.polygons,
    this.descriptiopns,
    this.search = false,
    this.customTitle,
  })  : assert(
          location == null || polygons == null,
          'Cannot provide both a location and polygons',
        ),
        super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  StreamSubscription<Position>? _positionStreamSubscription;
  MapShapeLayerController? _mapController;
  MapZoomPanBehavior? _zoomPan;

  bool? useGps;
  final List<MapLatLng> _currentPosition = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapShapeLayerController();
    _zoomPan = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      maxZoomLevel: 100.0,
    );
    if (widget.location != null) _currentPosition.add(widget.location!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final asPopup = widget.location != null || widget.polygons != null;
      if (!asPopup) showPositionOptions();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionStreamSubscription?.cancel();
    _mapController?.dispose();
    _currentPosition.clear();
  }

  @override
  Widget build(BuildContext context) {
    final onlySee = widget.location != null || widget.polygons != null;
    final isDark = AdaptiveTheme.of(context).brightness == Brightness.dark;
    final prefs = UserPreferences();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customTitle ?? AppLocalizations.of(context).map),
        actions: [
          if (!onlySee)
            IconButton(
              tooltip: AppLocalizations.of(context).locationMode,
              icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
              onPressed: showPositionOptions,
            ),
        ],
      ),
      body: FutureBuilder(
        future: Directory(p.join(File(prefs.dbPathNotifier.value!).parent.path, 'map')).list().toList(),
        builder: (_, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          const placeholder = Center(child: CircularProgressIndicator());
          if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) return placeholder;
          final files = (snapshot.data ?? []).whereType<File>();
          return FutureBuilder(
            future: deleteCountries(
              'assets/map/world_map.json',
              toDelete: files.map((f) => p.basenameWithoutExtension(f.path)).toList(),
            ),
            builder: (_, AsyncSnapshot<Uint8List> snapshot) {
              if (!snapshot.hasData) return placeholder;
              final bytesWorld = snapshot.data!;
              return FutureBuilder(
                future: Future.wait([for (final f in files) f.readAsBytes()]),
                builder: (_, AsyncSnapshot<List<Uint8List>> snapshot) {
                  final subLayers = <Uint8List>[];
                  if (snapshot.hasData) {
                    subLayers.addAll(snapshot.data!);
                  }
                  final strokeColor = isDark ? Colors.white : Colors.black;
                  final color = isDark ? Colors.white.withOpacity(0.5) : null;
                  return Stack(
                    children: [
                      SfMaps(
                        layers: [
                          MapShapeLayer(
                            controller: _mapController,
                            loadingBuilder: (_) => placeholder,
                            source: MapShapeSource.memory(bytesWorld),
                            strokeColor: strokeColor,
                            color: color,
                            zoomPanBehavior: _zoomPan,
                            sublayers: [
                              for (final sl in subLayers)
                                MapShapeSublayer(
                                  source: MapShapeSource.memory(sl),
                                  strokeColor: strokeColor,
                                  color: color,
                                ),
                              if (widget.polygons != null)
                                MapPolygonLayer(
                                  polygons: List.generate(
                                    widget.polygons!.length,
                                    (i) => MapPolygon(
                                      points: widget.polygons![i],
                                      strokeWidth: 0.0,
                                      color: Colors.blue.withOpacity(0.5),
                                      // onTap: () {
                                      //   final desc = widget.descriptiopns?[i];
                                      //   if (desc != null) {
                                      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      //     ScaffoldMessenger.of(context).showSnackBar(
                                      //       SnackBar(
                                      //         content: Text(desc),
                                      //         action: SnackBarAction(
                                      //           label: AppLocalizations.of(context).ok,
                                      //           onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                                      //         ),
                                      //       ),
                                      //     );
                                      //   }
                                      // },
                                    ),
                                  ).toSet(),
                                ),
                            ],
                            initialMarkersCount: _currentPosition.length,
                            markerBuilder: (_, i) => MapMarker(
                              latitude: _currentPosition[i].latitude,
                              longitude: _currentPosition[i].longitude,
                              alignment: Alignment.bottomCenter,
                              child: Icon(
                                Icons.location_on_rounded,
                                color: switch (useGps) {
                                  null => Colors.green,
                                  true => Colors.blue,
                                  false => Colors.red,
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onDoubleTap: () {},
                        onTapUp: useGps == null || useGps!
                            ? null
                            : (details) {
                                if (_mapController != null) {
                                  final p = _mapController?.pixelToLatLng(details.localPosition);
                                  _currentPosition.clear();
                                  _mapController?.clearMarkers();
                                  if (p != null) {
                                    _currentPosition.add(MapLatLng(p.latitude, p.longitude));
                                    _mapController?.insertMarker(0);
                                  }
                                }
                              },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: onlySee
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: getPosition,
                  child: const Icon(Icons.gps_fixed_rounded),
                ),
                const SizedBox.square(dimension: 20.0),
                FloatingActionButton.extended(
                  heroTag: 'search_near',
                  icon: const Icon(Icons.search_rounded),
                  label: Text(AppLocalizations.of(context).searchNearbySpecies),
                  onPressed: () {
                    if (_currentPosition.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context).setPointOnMap),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NearbySpeciesPage(_currentPosition[0])),
                      );
                    }
                  },
                ),
              ],
            ),
    );
  }

  showPositionOptions() => showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.gps_fixed_rounded),
                title: Text(AppLocalizations.of(context).gpsMode),
                trailing: Icon(useGps != null && useGps! ? Icons.radio_button_on : Icons.radio_button_off),
                onTap: () {
                  Navigator.pop(context);
                  if (useGps == null || !useGps!) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _currentPosition.clear();
                    _mapController?.clearMarkers();
                    setState(() => useGps = true);
                    getPosition();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_location_alt_rounded),
                title: Text(AppLocalizations.of(context).customLocationMode),
                trailing: Icon(useGps != null && !useGps! ? Icons.radio_button_on : Icons.radio_button_off),
                onTap: () {
                  Navigator.pop(context);
                  if (useGps == null || useGps!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context).customLocationModeString),
                      ),
                    );
                    _currentPosition.clear();
                    _mapController?.clearMarkers();
                    setState(() => useGps = false);
                    _positionStreamSubscription?.cancel();
                  }
                },
              ),
            ],
          );
        },
      );

  void getPosition() {
    if (useGps == null) {
      showPositionOptions();
    } else if (!useGps!) {
      if (_currentPosition.isNotEmpty) {
        _zoomPan?.focalLatLng = _currentPosition[0];
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).customLocationModeString),
          ),
        );
      }
    } else {
      Geolocator.isLocationServiceEnabled().then((enabled) {
        if (!enabled) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).noLocationEnabled),
            ),
          );
        } else {
          Geolocator.requestPermission().then((lp) {
            final hasPermission = lp == LocationPermission.always || lp == LocationPermission.whileInUse;
            if (!hasPermission) {
              openAppSettings().then((open) {
                if (!open) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).noLocationPermission),
                    ),
                  );
                }
              });
            } else if (_currentPosition.isNotEmpty) {
              _zoomPan?.focalLatLng = _currentPosition[0];
            } else {
              Geolocator.getCurrentPosition().then((position) {
                _currentPosition.clear();
                _mapController?.clearMarkers();
                _currentPosition.add(MapLatLng(position.latitude, position.longitude));
                _mapController?.insertMarker(0);
              });
            }
          });
        }
      });
    }
  }
}
