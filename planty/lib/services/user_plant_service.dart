import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/models/environmentreport.dart';
import 'package:planty/models/user_plant_detail_response.dart';
import 'package:planty/models/user_plant_edit_model.dart';
import 'package:planty/models/user_plant_summary_response.dart';
import 'package:http/http.dart' as http;

class UserPlantService {
  final _storage = FlutterSecureStorage();
  final _baseUrl = dotenv.env['BASE_URL']!;

  // 사용자의 반려 식물 목록 불러오기 - 홈화면
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

  // 사용자 반려 식물 상세 리포트
  Future<UserPlantDetailResponse> fetchUserPlantDetail(int userPlantId) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse('$_baseUrl/user-plants/$userPlantId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return UserPlantDetailResponse.fromJson(data);
    } else {
      throw Exception('반려식물 상세 정보 조회 실패');
    }
  }

  // 사용자 반려 식물 등록
  Future<int> registerUserPlant(
    int plantId,
    String nickname,
    String adoptedDate,
    int? personalityId,
    String imageUrl,
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
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body); // userPlantId
    } else {
      throw Exception('반려식물 등록 실패');
    }
  }

  // 반려식물에 IoT 기기 연결
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

  // 수정용 반려식물 정보 조회
  Future<UserPlantEditModel> fetchUserPlantForEdit(int userPlantId) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse('$_baseUrl/user-plants/edit/$userPlantId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return UserPlantEditModel.fromJson(data);
    } else {
      throw Exception('수정용 반려식물 정보 조회 실패');
    }
  }

  // 반려식물 정보 수정
  Future<void> editUserPlant(
    int userPlantId,
    UserPlantEditModel requestDto,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.put(
      Uri.parse('$_baseUrl/user-plants/edit/$userPlantId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestDto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('반려식물 정보 수정 실패');
    }
  }

  // 반려식물 삭제
  Future<void> deleteUserPlant(int userPlantId) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.delete(
      Uri.parse('$_baseUrl/user-plants/$userPlantId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('반려식물 삭제 실패');
    }
  }

  Future<EnvironmentReport> fetchEnvironmentReport(
    int userPlantId,
    String date,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse(
        '$_baseUrl/user-plants/$userPlantId/environment-report?date=$date',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return EnvironmentReport.fromJson(data);
    } else {
      throw Exception('환경 리포트 조회 실패');
    }
  }
}
