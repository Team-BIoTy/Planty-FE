import 'package:flutter/material.dart';
import 'package:planty/screens/home_screen.dart';
import 'package:planty/screens/my_screen.dart';
import 'package:planty/screens/plant_dictionary_screen.dart';
import 'package:planty/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planty',
      theme: ThemeData(fontFamily: 'NotoSansKR'),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/plants': (context) => const PlantDictionaryScreen(),
        '/chat': (context) => const HomeScreen(),
        '/my': (context) => const MyScreen(),
      },
    );
  }
}
