class ChatMessageResponse {
  final String sender; // "USER" or "BOT"
  final String message;
  final DateTime timestamp;

  ChatMessageResponse({
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      sender: json['sender'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
