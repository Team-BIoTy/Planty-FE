class UserPlantSummaryResponse {
  final int userPlantId;
  final String nickname;
  final String imageUrl;
  final DateTime adoptedAt;
  final Status status;
  final Personality personality;

  UserPlantSummaryResponse({
    required this.userPlantId,
    required this.nickname,
    required this.imageUrl,
    required this.adoptedAt,
    required this.status,
    required this.personality,
  });

  factory UserPlantSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserPlantSummaryResponse(
      userPlantId: json['userPlantId'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
      adoptedAt: DateTime.parse(json['adoptedAt']),
      status: Status.fromJson(json['status']),
      personality: Personality.fromJson(json['personality']),
    );
  }
}

class Status {
  final int temperatureScore;
  final int lightScore;
  final int humidityScore;
  final String message;

  Status({
    required this.temperatureScore,
    required this.lightScore,
    required this.humidityScore,
    required this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      temperatureScore: json['temperatureScore'],
      lightScore: json['lightScore'],
      humidityScore: json['humidityScore'],
      message: json['message'].replaceAll(r'\\n', '\n'),
    );
  }
}

class Personality {
  final String label;
  final String emoji;
  final String color;

  Personality({required this.label, required this.emoji, required this.color});

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      label: json['label'],
      emoji: json['emoji'],
      color: json['color'],
    );
  }
}
