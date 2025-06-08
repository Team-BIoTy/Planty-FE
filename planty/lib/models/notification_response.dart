class NotificationResponse {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime receivedAt;
  final String plantNickname;
  final String plantImageUrl;

  NotificationResponse({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.receivedAt,
    required this.plantNickname,
    required this.plantImageUrl,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isRead: json['read'],
      receivedAt: DateTime.parse(json['receivedAt']),
      plantNickname: json['plantNickname'] ?? '',
      plantImageUrl: json['plantImageUrl'] ?? '',
    );
  }
}
