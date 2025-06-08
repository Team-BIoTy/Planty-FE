import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planty/screens/chat/chat_list_screen.dart';
import 'package:planty/screens/home/home_screen.dart';
import 'package:planty/screens/my/my_screen.dart';
import 'package:planty/screens/plant/plant_dictionary_screen.dart';
import 'package:planty/screens/onboarding/splash_screen.dart';
import 'package:planty/services/fcm_service.dart';
import 'package:permission_handler/permission_handler.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final fcmService = FcmService();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);
  await flutterLocalNotificationsPlugin.initialize(settings);

  final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'planty_channel',
      'Planty 알림',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Colors.white,
    ),
  );

  final title = message.data['title'] ?? '알림';
  final body = message.data['body'] ?? '내용 없음';

  await flutterLocalNotificationsPlugin.show(
    title.hashCode,
    title,
    body,
    notificationDetails,
  );
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied || status.isRestricted) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await dotenv.load();
  await Firebase.initializeApp();
  await requestNotificationPermission();
  await fcmService.initLocalNotification();

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("FCM 토큰 갱신됨: $newToken");
    fcmService.sendDeviceTokenToServer(newToken);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📥 FCM 수신됨");
    final title = message.data['title'];
    final body = message.data['body'];
    fcmService.showNotification(RemoteNotification(title: title, body: body));
  });

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
