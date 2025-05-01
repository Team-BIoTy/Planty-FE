import 'package:flutter/material.dart';
import 'package:planty/screens/home/home_screen.dart';
import 'package:planty/screens/my/my_screen.dart';
import 'package:planty/screens/plant/plant_dictionary_screen.dart';
import 'package:planty/screens/onboarding/splash_screen.dart';

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
