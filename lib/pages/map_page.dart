import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/maps.dart';
import 'package:mapsforge_flutter/marker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

Position? position;

class MapPage extends StatefulWidget {
  final dynamic location;

  const MapPage({
    Key? key,
    this.location,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).map),
      ),
      body: FutureBuilder(
        future: File(p.join(UserPreferences().dbPath, 'maps/map.map')).exists(),
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final exists = snapshot.data!;
          if (!exists) {
            return Center(child: Text(AppLocalizations.of(context).fileNotFound));
          }
          return MapviewWidget(
            displayModel: displayModel,
            createMapModel: _createMapModel,
            createViewModel: _createViewModel,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location_outlined),
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }

  final displayModel = DisplayModel(deviceScaleFactor: 2);
  final symbolCache = FileSymbolCache();
  final markerDataStore = MarkerDataStore();

  Future<MapModel> _createMapModel() async {
    final file = File(p.join(UserPreferences().dbPath, 'maps/map.map'));
    final mapFile = await MapFile.using(
      (await file.readAsBytes()),
      null,
      null,
    );
    final renderTheme = await RenderThemeBuilder.create(
      displayModel,
      'assets/map_resources/render.xml',
    );

    return MapModel(
      displayModel: displayModel,
      renderer: MapDataStoreRenderer(
        mapFile,
        renderTheme,
        symbolCache,
        true,
      ),
    )..markerDataStores.add(markerDataStore);
  }

  Future<ViewModel> _createViewModel() async {
    ViewModel viewModel = ViewModel(displayModel: displayModel);
    // set the initial position
    print('view');
    viewModel.setMapViewPosition(
      position?.latitude ?? 23.053847,
      position?.longitude ?? -82.417690,
    );
    // set the initial zoomlevel
    viewModel.setZoomLevel(16);
    // bonus feature: listen for long taps and add/remove a marker at the tap-positon
    viewModel.addOverlay(_MarkerOverlay(
      displayModel: displayModel,
      symbolCache: symbolCache,
      viewModel: viewModel,
      markerDataStore: markerDataStore,
    ));
    return viewModel;
  }
}

/// An overlay is just a normal widget which will be drawn on top of the map. In this case we do not
/// draw anything but just receive long tap events and add/remove a marker to the datastore. Take note
/// that the marker needs to be initialized (async) and afterwards added to the datastore and the
/// setRepaint() method is called to inform the datastore about changes so that it gets repainted
class _MarkerOverlay extends StatefulWidget {
  final MarkerDataStore markerDataStore;

  final ViewModel viewModel;

  final SymbolCache symbolCache;

  final DisplayModel displayModel;

  const _MarkerOverlay({
    required this.viewModel,
    required this.markerDataStore,
    required this.symbolCache,
    required this.displayModel,
  });

  @override
  State<StatefulWidget> createState() => _MarkerOverlayState();
}

class _MarkerOverlayState extends State {
  @override
  _MarkerOverlay get widget => super.widget as _MarkerOverlay;

  PoiMarker? _marker;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Geolocator.getPositionStream(locationSettings: const LocationSettings()),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.data == null) return const SizedBox();
          if (_marker != null) {
            widget.markerDataStore.removeMarker(_marker!);
          }

          position = snapshot.data!;

          _marker = PoiMarker(
            displayModel: widget.displayModel,
            src: 'assets/map_resources/marker.svg',
            height: 32,
            width: 24,
            latLong: LatLong(
              position!.latitude,
              position!.longitude,
            ),
            // position: Position.ABOVE,
          );

          _marker!.initResources(widget.symbolCache).then((value) {
            widget.markerDataStore.addMarker(_marker!);
            widget.markerDataStore.setRepaint();
          });

          return const SizedBox();
        });
  }
}
