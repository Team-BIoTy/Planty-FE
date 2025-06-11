import 'package:planty/models/chat_message.dart';
import 'package:planty/models/plant_info_detail.dart';

class ChatRoomDetail {
  final int chatRoomId;
  final int userPlantId;
  final String? userPlantNickname;
  final String? imageUrl;
  final String? personalityLabel;
  final String? personalityEmoji;
  final String? personalityColor;
  final int? sensorLogId;
  final int? plantEnvStandardsId;
  final List<ChatMessage> messages;
  final PlantInfoDetail? plantInfoDetail;

  ChatRoomDetail({
    required this.chatRoomId,
    required this.userPlantId,
    required this.userPlantNickname,
    required this.imageUrl,
    required this.personalityLabel,
    required this.personalityEmoji,
    required this.personalityColor,
    this.sensorLogId,
    this.plantEnvStandardsId,
    required this.messages,
    this.plantInfoDetail,
  });

  factory ChatRoomDetail.fromJson(Map<String, dynamic> json) {
    return ChatRoomDetail(
      chatRoomId: json['chatRoomId'],
      userPlantId: json['userPlantId'],
      userPlantNickname: json['userPlantNickname'],
      imageUrl: json['imageUrl'] ?? '',
      personalityLabel: json['personalityLabel'],
      personalityEmoji: json['personalityEmoji'],
      personalityColor: json['personalityColor'],
      sensorLogId: json['sensorLogId'],
      plantEnvStandardsId: json['plantEnvStandardsId'],
      messages:
          (json['messages'] as List)
              .map((e) => ChatMessage.fromJson(e))
              .toList(),
      plantInfoDetail:
          json['plantInfo'] != null
              ? PlantInfoDetail.fromJson(json['plantInfo'])
              : null,
    );
  }
}
