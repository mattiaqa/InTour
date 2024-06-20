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
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/constants.dart';

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
                return PercorsoTile(
                  title: percorso.title ?? '',
                  category: percorso.category ?? '',
                  imageName: percorso.imageName ?? '',
                  description: percorso.description ?? '',
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

    await addSource(
      await _fetchPercorsi(),
    );
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
            12.144494,
            45.977278,
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

  String eventsGeoJson(List<Percorso> trails) {
    return jsonEncode(
      {
        'type': 'FeatureCollection',
        'features': trails.map((trail) {
          return {
            'type': 'Feature',
            'geometry': Point(
              coordinates: Position(
                trail.coords!.y,
                trail.coords!.x,
              ),
            ).toJson(),
            'properties': trail.toJson(),
          };
        }).toList()
      },
    );
  }

  Future<List<Percorso>> _fetchPercorsi() async {
    var response = await ApiManager.fetchData('trails');
    if (response != null) {
      response = response.replaceAll(' NaN,', '"NaN",');
      var results = jsonDecode(response) as List?;

      if (results != null) {
        return results.map((e) => Percorso.fromJson(e)).toList();
      }
    }
    return [];
  }
}

class PercorsoTile extends StatelessWidget {
  String? title;
  String? category;
  String? imageUrl;
  String? description;
  String? imageName;

  void Function()? onTap;

  PercorsoTile({
    required this.title,
    required this.category,
    required this.description,
    required this.imageName,
    this.onTap,
  });

  factory PercorsoTile.fromJson(Map<String, dynamic> json) {
    return PercorsoTile(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      imageName: json['imageName'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "http://$myIP:8000/api/uploads/trails/$imageName",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
