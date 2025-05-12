import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/models/iot_device.dart';
import 'package:http/http.dart' as http;

class IotDeviceService {
  final _storage = FlutterSecureStorage();
  final String _baseUrl = 'http://localhost:8080';

  Future<List<IotDevice>> fetchUserIotDevices() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse('$_baseUrl/iot'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => IotDevice.fromJson(json)).toList();
    } else {
      throw Exception('IoT 디바이스 불러오기 실패');
    }
  }
}
