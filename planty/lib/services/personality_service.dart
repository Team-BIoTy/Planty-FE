import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planty/models/personality.dart';
import 'package:http/http.dart' as http;

class PersonalityService {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<List<Personality>> fetchPersonalities() async {
    final response = await http.get(Uri.parse('$_baseUrl/personalities'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Personality.fromJson(json)).toList();
    } else {
      throw Exception('성격 불러오기 실패');
    }
  }
}
