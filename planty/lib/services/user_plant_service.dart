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

  Future<int> registerUserPlant(
    int plantId,
    String nickname,
    String adoptedDate,
    int? personalityId,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');
    final response = await http.post(
      Uri.parse('$_baseUrl/user-plants'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plantInfoId': plantId,
        'nickname': nickname,
        'adoptedAt': adoptedDate,
        'personalityId': personalityId,
        'imageUrl': '',
      }),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body); // userPlantId
    } else {
      throw Exception('반려식물 등록 실패');
    }
  }

  Future<void> registerIotDevice(int userPlantId, int deviceId) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');
    final response = await http.post(
      Uri.parse('$_baseUrl/user-plants/$userPlantId/device'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'iotDeviceId': deviceId}),
    );

    if (response.statusCode != 200) {
      throw Exception('IoT 기기 등록 실패');
    }
  }
}
