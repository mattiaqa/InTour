import 'dart:convert';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Screens/Percorsi/dettagli_percorso.dart';
import 'package:frontend/Screens/Map/domain/map_assets.dart';
import 'package:frontend/Screens/Map/domain/map_keys.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap _controller;
  @override
  Widget build(BuildContext context) {
    return MapWidget(
      cameraOptions: _cameraOptions,
      onStyleLoadedListener: _onStyleLoadedListener,
      onMapCreated: _onMapCreated,
      onTapListener: (value) => _onTapListener(value).then((percorsi) {
        if ((percorsi ?? []).isEmpty) {
          return;
        }
        showModalBottomSheet(
          context: context,
          builder: (context) => ListView.builder(
            itemBuilder: (context, index) {
              final percorso = percorsi?[index];
              if (percorso != null) {
                return ListTile(
                  title: Text(percorso.title ?? ''),
                  subtitle: Text(percorso.description ?? ''),
                  onTap: () => context.push(
                    '/percorso',
                    extra: percorso,
                  ),
                );
              }
              return null;
            },
            itemCount: percorsi?.length,
          ),
        );
      }),
    );
  }

  Future<void> _onMapCreated(MapboxMap controller) async {
    setState(() {
      _controller = controller;
      updateMapSettings();
    });
  }

  Future<List<Percorso>?> _onTapListener(
      MapContentGestureContext coordinate) async {
    final ScreenCoordinate? screenCoordinate =
        await _controller.pixelForCoordinate(coordinate.point);
    if (screenCoordinate != null) {
      final clusterEvents = await queryCluster(screenCoordinate);
      if (clusterEvents != null) {
        return clusterEvents;
      } else {
        return await queryPoint(screenCoordinate);
      }
    }
    return null;
  }

  Future<List<Percorso>?> queryCluster(
      ScreenCoordinate screenCoordinate) async {
    final List<QueriedRenderedFeature?>? pointFeatures =
        await _controller.queryRenderedFeatures(
      RenderedQueryGeometry(
        value: jsonEncode(
          screenCoordinate.encode(),
        ),
        type: Type.SCREEN_COORDINATE,
      ),
      RenderedQueryOptions(
        layerIds: [
          MapKeys.clusterCount,
        ],
      ),
    );

    for (QueriedRenderedFeature? pointFeature in pointFeatures ?? []) {
      if (pointFeature != null) {
        final clusterChildren = await _controller.getGeoJsonClusterLeaves(
          pointFeature.queriedFeature.source,
          pointFeature.queriedFeature.feature,
          null,
          null,
        );
        final groupedFeatures = groupBy(
          clusterChildren.featureCollection ?? [],
          (element) => element['geometry']['coordinates'].toString(),
        );
        final pointHasMultipleEvents =
            groupedFeatures.values.any((element) => element.isNotEmpty) &&
                groupedFeatures.keys.length == 1;
        if (pointHasMultipleEvents) {
          final events = clusterChildren.featureCollection
                  ?.map((e) => Percorso.fromJson(
                      jsonDecode(jsonEncode(e?['properties']))))
                  .toList() ??
              [];
          await moveToPoint(
            Position.fromJson(
              (clusterChildren.featureCollection?.first?['geometry']
                      as Map)['coordinates']!
                  .cast<num>(),
            ),
          );
          return events;
        } else {
          final position = Position.fromJson(
            (pointFeature.queriedFeature.feature['geometry']
                    as Map)['coordinates']!
                .cast<num>(),
          );
          await moveToPoint(position, zoom: true);
        }
      }
    }
    return null;
  }

  Future<List<Percorso>?> queryPoint(ScreenCoordinate screenCoordinate) async {
    final List<QueriedRenderedFeature?>? pointFeatures =
        await _controller.queryRenderedFeatures(
      RenderedQueryGeometry(
        value: jsonEncode(
          screenCoordinate.encode(),
        ),
        type: Type.SCREEN_COORDINATE,
      ),
      RenderedQueryOptions(
        layerIds: [
          MapKeys.eventsLayer,
        ],
      ),
    );

    if (pointFeatures?.firstOrNull != null) {
      moveToPoint(
        Position.fromJson(
          (pointFeatures?.firstOrNull?.queriedFeature.feature['geometry']
                  as Map)['coordinates']!
              .cast<num>(),
        ),
      );
      return [
        Percorso.fromJson(
          jsonDecode(
            jsonEncode(
              pointFeatures?.firstOrNull?.queriedFeature.feature['properties'],
            ),
          ),
        ),
      ];
    }
    return null;
  }

  Future<void> moveToPoint(Position position, {bool zoom = false}) async {
    CameraState cameraState = await _controller.getCameraState();
    await _controller.flyTo(
      CameraOptions(
        center: Point(coordinates: position),
        zoom: cameraState.zoom + (zoom ? 1.5 : 0),
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  Future<void> _onStyleLoadedListener(
      StyleLoadedEventData styleLoadedEventData) async {
    _controller.style.styleLayerExists(MapKeys.clusters).then((value) async {
      if (!value) {
        await addStyleImage();
        var layer = await rootBundle.loadString(MapAssets.clusterLayer);
        _controller.style.addStyleLayer(layer, null);
        var clusterCountLayer = await rootBundle.loadString(
          MapAssets.clusterCountLayer,
        );
        _controller.style.addStyleLayer(clusterCountLayer, null);
        var unclusteredLayer = await rootBundle.loadString(
          MapAssets.unclusteredPointLayer,
        );
        _controller.style.addStyleLayer(unclusteredLayer, null);
      }
    });
    // FAI LA CHIAMATA PER PRENDERTI I PERCORSI E PASSALI COME ARRAY
    await addSource([
      Percorso(
        category: 'category',
        imageName: 'imageName',
        title: 'title',
        summary: 'summary',
        description: 'description',
        tips: 'tips',
        length: 'length',
        security: 'security',
        equipment: 'equipment',
        references: 'references',
        startpoint: 'startpoint',
        endpoint: 'endpoint',
        climb: 'climb',
        descent: 'descent',
        difficulty: 'difficulty',
        duration: 'duration',
        coords: 'coords',
      ),
    ]);
  }

  Future<void> addStyleImage() async {
    final ByteData bytesMarker = await rootBundle.load(
      'assets/images/marker.png',
    );
    final Uint8List listMarker = bytesMarker.buffer.asUint8List();

    // GET IMAGE DIMENSIONS FOR ANDROID
    final buffer = await ImmutableBuffer.fromUint8List(listMarker);
    final descriptor = await ImageDescriptor.encoded(buffer);

    _controller.style.addStyleImage(
      MapKeys.eventMarker,
      3,
      MbxImage(
        width: descriptor.width,
        height: descriptor.height,
        data: listMarker,
      ),
      false,
      [],
      [],
      null,
    );
  }

  Future<void> updateMapSettings() async {
    await _controller.setBounds(
      CameraBoundsOptions(maxZoom: 17, minZoom: 5),
    );
    await _controller.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );
    await _controller.scaleBar.updateSettings(
      ScaleBarSettings(enabled: false),
    );
    await _controller.compass.updateSettings(
      CompassSettings(
        enabled: false,
      ),
    );
    await _controller.gestures.updateSettings(
      GesturesSettings(pitchEnabled: false, rotateEnabled: false),
    );
    await _controller.attribution.updateSettings(
      AttributionSettings(
        position: OrnamentPosition.BOTTOM_LEFT,
        marginBottom: 8,
        marginLeft: 86,
      ),
    );
  }

  CameraOptions get _cameraOptions => CameraOptions(
        zoom: 10,
        center: Point(
          coordinates: Position(
            12.244007095329533,
            45.66746798861351,
          ),
        ),
      );

  Future<void> addSource(List<Percorso> data) async {
    final sourceExists = await _controller.style.styleSourceExists(
      MapKeys.eventsStyleSource,
    );
    if (sourceExists == true) {
      final source = await _controller.style.getSource(
        MapKeys.eventsStyleSource,
      ) as GeoJsonSource;
      await source.updateGeoJSON(eventsGeoJson(data));
    } else {
      await _controller.style.addSource(
        GeoJsonSource(
          id: MapKeys.eventsStyleSource,
          cluster: true,
          data: eventsGeoJson(data),
        ),
      );
    }
  }

  String eventsGeoJson(List<Percorso> events) {
    return jsonEncode(
      {
        'type': 'FeatureCollection',
        'features': events.map((event) {
          return {
            'type': 'Feature',
            'geometry': Point(
              coordinates: Position(
                // IN QUESTO PUNTO DEVI PASSARE LE COORDINATE DEL PERCORSO: SOSTITUISCI 0,0 CON LE RISPETTIVE COORDINATE
                12.244007095329533,
                45.66746798861351,
                //event.addressData.coordinates.y,
                // event.addressData.coordinates.x,
              ),
            ).toJson(),
            'properties': event.toJson(),
          };
        }).toList()
      },
    );
  }
}
