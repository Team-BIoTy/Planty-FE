import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planty/screens/chat/chat_list_screen.dart';
import 'package:planty/screens/home/home_screen.dart';
import 'package:planty/screens/my/my_screen.dart';
import 'package:planty/screens/plant/plant_dictionary_screen.dart';
import 'package:planty/screens/onboarding/splash_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await dotenv.load();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planty',
      theme: ThemeData(fontFamily: 'NotoSansKR'),
      navigatorObservers: [routeObserver],
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/plants': (context) => const PlantDictionaryScreen(),
        '/chat': (context) => const ChatListScreen(),
        '/my': (context) => const MyScreen(),
      },
    );
  }
}
