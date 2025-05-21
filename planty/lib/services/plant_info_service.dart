import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planty/models/plant_info.dart';
import 'package:http/http.dart' as http;
import 'package:planty/models/plant_info_detail.dart';

class PlantInfoService {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<List<PlantInfo>> fetchPlantLists() async {
    final response = await http.get(Uri.parse('$_baseUrl/plants'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => PlantInfo.fromJson(json)).toList();
    } else {
      throw Exception('식물 리스트 불러오기 실패');
    }
  }

  Future<PlantInfoDetail> fetchPlantDetail(int plantId) async {
    final response = await http.get(Uri.parse('$_baseUrl/plants/$plantId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(
        utf8.decode(response.bodyBytes),
      );
      return PlantInfoDetail.fromJson(jsonData);
    } else {
      throw Exception('식물 상세 정보 불러오기 실패');
    }
  }
}
