class ChatRoom {
  final int chatRoomId;
  final String userPlantNickname;
  final String lastMessage;
  final DateTime lastSentAt;
  final String imageUrl;
  bool get isQa => userPlantNickname == '식물챗봇';

  ChatRoom({
    required this.chatRoomId,
    required this.userPlantNickname,
    required this.lastMessage,
    required this.lastSentAt,
    required this.imageUrl,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatRoomId: json['chatRoomId'],
      userPlantNickname: json['userPlantNickname'],
      lastMessage: json['lastMessage'],
      lastSentAt: DateTime.parse(json['lastSentAt']),
      imageUrl: json['imageUrl'],
    );
  }
}
