import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/models/user_plant_summary_response.dart';
import 'package:http/http.dart' as http;

class UserPlantService {
  final _storage = FlutterSecureStorage();
  final _baseUrl = 'http://localhost:8080';

  Future<List<UserPlantSummaryResponse>> fetchUserPlants() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse('$_baseUrl/user-plants'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => UserPlantSummaryResponse.fromJson(e)).toList();
    } else {
      throw Exception('식물 목록 불러오기 실패');
    }
  }
}
