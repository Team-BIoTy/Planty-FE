import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FcmService {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<void> sendDeviceTokenToServer(String jwtToken) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      print("FCM 토근이 null입니다.");
      return;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/fcm/token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({'token': fcmToken}),
    );

    if (response.statusCode == 200) {
      print("FCM 토큰 전송 성공!");
    } else {
      print("전송 실패: ${response.statusCode} ${response.body}");
    }
  }
}
