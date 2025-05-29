class UserPlantSummaryResponse {
  final int userPlantId;
  final String nickname;
  final String imageUrl;
  final DateTime adoptedAt;
  final Status? status;
  final Personality personality;
  final Map<String, bool> runningCommands;

  UserPlantSummaryResponse({
    required this.userPlantId,
    required this.nickname,
    required this.imageUrl,
    required this.adoptedAt,
    required this.status,
    required this.personality,
    required this.runningCommands,
  });

  factory UserPlantSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserPlantSummaryResponse(
      userPlantId: json['userPlantId'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
      adoptedAt: DateTime.parse(json['adoptedAt']),
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      personality: Personality.fromJson(json['personality']),
      runningCommands: Map<String, bool>.from(json['runningCommands'] ?? {}),
    );
  }
}

class Status {
  final int temperatureScore;
  final int lightScore;
  final int humidityScore;
  final String message;
  final DateTime checkedAt;

  Status({
    required this.temperatureScore,
    required this.lightScore,
    required this.humidityScore,
    required this.message,
    required this.checkedAt,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      temperatureScore: json['temperatureScore'] ?? 3,
      lightScore: json['lightScore'] ?? 3,
      humidityScore: json['humidityScore'] ?? 3,
      message: (json['message'] ?? 'IoT 기기 연결 상태를 확인해 주세요 🔧').replaceAll(
        r'\\n',
        '\n',
      ),
      checkedAt: DateTime.parse(json['checkedAt']),
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
