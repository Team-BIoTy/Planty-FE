import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:planty/services/fcm_service.dart';

class AuthService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final fcmService = FcmService();

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final jwtToken = json['token'];

      await fcmService.sendDeviceTokenToServer(jwtToken);
      return jwtToken;
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }

  Future<void> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('회원가입 실패: ${response.statusCode}');
    }
  }

  Future<bool> validToken(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/validate'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('validateToken 응답 코드: ${response.statusCode}');

    return response.statusCode == 200;
  }

  Future<void> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final msg = utf8.decode(response.bodyBytes);
      throw Exception('비밀번호 변경 실패: $msg');
    }
  }

  Future<void> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/auth/delete'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final msg = utf8.decode(response.bodyBytes);
      throw Exception('회원 탈퇴 실패: $msg');
    }
  }

  Future<Map<String, dynamic>> fetchMyInfo(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('유저 정보 불러오기 실패');
    }
  }

  Future<void> updateAdafruitAccount({
    required String token,
    required String username,
    required String apiKey,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/auth/adafruit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username, 'apiKey': apiKey}),
    );

    if (response.statusCode != 200) {
      final msg = utf8.decode(response.bodyBytes);
      throw Exception('Adafruit 계정 업데이트 실패: $msg');
    }
  }
}
