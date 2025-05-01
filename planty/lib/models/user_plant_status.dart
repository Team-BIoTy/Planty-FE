class UserPlantStatus {
  final int temperatureScore;
  final int lightScore;
  final int humidityScore;
  final String statusMessage;
  final DateTime checkedAt;

  UserPlantStatus({
    required this.temperatureScore,
    required this.lightScore,
    required this.humidityScore,
    required this.statusMessage,
    required this.checkedAt,
  });

  factory UserPlantStatus.fromJson(Map<String, dynamic> json) {
    return UserPlantStatus(
      temperatureScore: json['temperatureScore'],
      lightScore: json['lightScore'],
      humidityScore: json['humidityScore'],
      statusMessage: json['statusMessage'],
      checkedAt: DateTime.parse(json['checkedAt']),
    );
  }
}
