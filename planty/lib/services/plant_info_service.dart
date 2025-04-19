import 'dart:convert';

import 'package:planty/models/plant_info.dart';
import 'package:http/http.dart' as http;

class PlantInfoService {
  final String _baseUrl = 'http://localhost:8080';

  Future<List<PlantInfo>> fetchPlantLists() async {
    final response = await http.get(Uri.parse('$_baseUrl/plants'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => PlantInfo.fromJson(json)).toList();
    } else {
      throw Exception('식물 리스트 불러오기 실패');
    }
  }
}
