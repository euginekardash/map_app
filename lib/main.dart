import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init.initMapkit(apiKey: '052d9851-ca36-457c-af38-f2b153436197');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  MapWindow? _mapWindow;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YandexMap(onMapCreated: (mapWindow) => _mapWindow = mapWindow)
      )
    );
  }
}