import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/models/chat_message.dart';
import 'package:planty/models/chat_room.dart';
import 'package:http/http.dart' as http;
import 'package:planty/models/chat_room_detail.dart';

class ChatService {
  final _storage = FlutterSecureStorage();
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<List<ChatRoom>> fetchChatRooms() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.get(
      Uri.parse('$_baseUrl/chats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ChatRoom.fromJson(json)).toList();
    } else {
      throw Exception('채팅방 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<int> startChat({int? userPlantId}) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('토큰 없음');

    final response = await http.post(
      Uri.parse('$_baseUrl/chats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userPlantId': userPlantId}), // null도 가능
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['chatRoomId'];
    } else {
      throw Exception('채팅방 생성 실패: ${response.statusCode}');
    }
  }

  // 채팅방 진입 시 (반려식물 기본정보 + 채팅 메시지 불러오기)
  Future<ChatRoomDetail> fetchChatRoomDetail(int chatRoomId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$_baseUrl/chats/$chatRoomId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ChatRoomDetail.fromJson(data);
    } else {
      throw Exception('채팅방 상세 조회 실패');
    }
  }

  // 채팅 전송
  Future<ChatMessage> sendMessage(int chatRoomId, String message) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$_baseUrl/chats/$chatRoomId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ChatMessage.fromJson(data);
    } else {
      throw Exception('메시지 전송 실패');
    }
  }
}
