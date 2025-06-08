import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planty/models/notification_response.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final _storage = FlutterSecureStorage();
  final _baseUrl = dotenv.env['BASE_URL']!;

  Future<List<NotificationResponse>> fetchNotificationsFromJwt() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse('$_baseUrl/notifications/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => NotificationResponse.fromJson(e)).toList();
    } else {
      throw Exception('알림 목록 불러오기 실패');
    }
  }

  Future<void> markAllAsRead() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.patch(
      Uri.parse('$_baseUrl/notifications/me/read-all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('전체 알림 읽음 처리 실패');
    }
  }
}
