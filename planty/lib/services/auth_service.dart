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
}
