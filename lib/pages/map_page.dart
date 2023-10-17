import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapPage extends StatefulWidget {
  final MapLatLng? location;
  final List<List<MapLatLng>>? polygons;
  final bool search;

  const MapPage({
    Key? key,
    this.location,
    this.polygons,
    this.search = false,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPositionOptions();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).map),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).locationMode,
            icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
            onPressed: showPositionOptions,
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          rootBundle.load('assets/map/world_map.json'),
        ]),
        builder: (_, AsyncSnapshot<List<ByteData>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bytesWorld = snapshot.data![0].buffer.asUint8List();
          final isDark = AdaptiveTheme.of(context).brightness == Brightness.dark;
          return Stack(
            children: [
              SfMaps(
                layers: [
                  MapShapeLayer(
                    controller: _mapController,
                    loadingBuilder: (_) => const Center(child: CircularProgressIndicator()),
                    source: MapShapeSource.memory(bytesWorld),
                    strokeColor: isDark ? Colors.white : Colors.black,
                    color: isDark ? Colors.white.withOpacity(0.5) : null,
                    zoomPanBehavior: _zoomPan,
                    // sublayers: [
                    // MapShapeSublayer(source: MapShapeSource.memory(bytesCuba!)),
                    // MapPolygonLayer(
                    //   polygons: List.generate(
                    //     polygons!.length,
                    //     (i) => MapPolygon(
                    //       points: polygons![i],
                    //       strokeWidth: 0.0,
                    //       color: Colors.blue.withOpacity(0.5),
                    //     ),
                    //   ).toSet(),
                    // ),
                    // ],
                    initialMarkersCount: _currentPosition.length,
                    markerBuilder: (_, i) => MapMarker(
                      latitude: _currentPosition[i].latitude,
                      longitude: _currentPosition[i].longitude,
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: switch (useGps) {
                          null => null,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPosition,
        child: const Icon(Icons.gps_fixed_rounded),
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
    Geolocator.isLocationServiceEnabled().then((enabled) {
      if (!enabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).noLocationEnabled),
          ),
        );
        return;
      }
      Geolocator.requestPermission().then((lp) {
        final hasPermission = lp == LocationPermission.always || lp == LocationPermission.whileInUse;
        if (!hasPermission) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).noLocationPermission),
            ),
          );
          return;
        }
        if (_currentPosition.isNotEmpty) {
          _zoomPan?.focalLatLng = _currentPosition[0];
        } else {
          if (useGps == null) {
            showPositionOptions();
          } else {
            if (useGps!) {
              Geolocator.getCurrentPosition().then((position) {
                _currentPosition.clear();
                _mapController?.clearMarkers();
                _currentPosition.add(MapLatLng(position.latitude, position.longitude));
                _mapController?.insertMarker(0);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context).customLocationModeString),
                ),
              );
            }
          }
        }
      });
    });
  }
}
