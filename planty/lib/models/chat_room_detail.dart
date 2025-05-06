import 'package:planty/models/chat_message.dart';

class ChatRoomDetail {
  final int chatRoomId;
  final String? userPlantNickname;
  final String? imageUrl;
  final String? personalityLabel;
  final String? personalityEmoji;
  final String? personalityColor;
  final List<ChatMessage> messages;

  ChatRoomDetail({
    required this.chatRoomId,
    required this.userPlantNickname,
    required this.imageUrl,
    required this.personalityLabel,
    required this.personalityEmoji,
    required this.personalityColor,
    required this.messages,
  });

  factory ChatRoomDetail.fromJson(Map<String, dynamic> json) {
    return ChatRoomDetail(
      chatRoomId: json['chatRoomId'],
      userPlantNickname: json['userPlantNickname'],
      imageUrl: json['imageUrl'] ?? '',
      personalityLabel: json['personalityLabel'],
      personalityEmoji: json['personalityEmoji'],
      personalityColor: json['personalityColor'],
      messages:
          (json['messages'] as List)
              .map((e) => ChatMessage.fromJson(e))
              .toList(),
    );
  }
}
