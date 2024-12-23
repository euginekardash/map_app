
import 'package:flutter/material.dart';
import 'package:todo_sqlite/screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Map',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MapScreen(),
    );
  }
}


