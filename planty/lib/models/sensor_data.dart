class SensorData {
  final double temperature;
  final double humidity;
  final double light;
  final DateTime recordedAt;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.recordedAt,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      light: (json['light'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt']),
    );
  }
}
