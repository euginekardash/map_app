import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_sqlite/services/app_lat_long.dart';
import 'package:todo_sqlite/services/yandex_map_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _mapControllerCompleter = Completer();
  AppLatLong _currentLocation = const MinskLocation();
  static const AppLatLong _defaultLocation = MinskLocation();
  List<MapObject> mapObject = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _initPermission();
    await _fetchCurrentLocation();
  }

  Future<void> _initPermission() async {
    final hasPermission = await LocationService().checkPermission();
    if (!hasPermission) {
      final granted = await LocationService().requestPermission();
      if (!granted) {
        return;
      }
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final location = await LocationService().getCurrentLocation();
      setState(() {
        _currentLocation = location;
      });
      _moveToCurrentLocation(_currentLocation);
    } catch (e) {
      setState(() {
        _currentLocation = _defaultLocation;
      });
      _moveToCurrentLocation(_currentLocation);
    }
  }

  Future<void> _moveToCurrentLocation(AppLatLong location) async {
    addObject(location);
    final controller = await _mapControllerCompleter.future;
    controller.moveCamera(
      animation: const MapAnimation(
        type: MapAnimationType.linear,
        duration: 1,
      ),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: location.lat,
            longitude: location.long,
          ),
          zoom: 14,
        ),
      ),
    );
  }

  void addObject(AppLatLong appLatLong) {
    final myLocationMarker = PlacemarkMapObject(
        mapId: const MapObjectId('currentLocation'),
        point: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image:
                BitmapDescriptor.fromAssetImage('assets/icons/map_point.png'),
            rotationType: RotationType.rotate)));

    final currentLocationCircle = CircleMapObject(
        mapId: const MapObjectId('currentLocationCircle'),
        circle: Circle(
            center: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
            radius: 250),
        strokeWidth: 0,
        fillColor: Colors.blue.withOpacity(0.2),
        );

    mapObject.addAll([currentLocationCircle, myLocationMarker]);
  }

  void addMark(Point point) {
    final marker = PlacemarkMapObject(
        mapId: const MapObjectId('marker'),
        point: point,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image:
                BitmapDescriptor.fromAssetImage('assets/icons/map_point.png'),
            rotationType: RotationType.noRotation)));
    mapObject.add(marker);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (controller) {
          if (!_mapControllerCompleter.isCompleted) {
            _mapControllerCompleter.complete(controller);
          }
        },
        onMapTap: (point) {
          //addMark(point);
        },
        mapObjects: mapObject,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {_fetchCurrentLocation();},child: const Icon(Icons.navigation_rounded),),
    );
  }
}
