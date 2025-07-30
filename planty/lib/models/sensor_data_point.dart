class SensorDataPoint {
  final String time;
  final double value;

  SensorDataPoint({required this.time, required this.value});

  factory SensorDataPoint.fromJson(Map<String, dynamic> json) {
    return SensorDataPoint(
      time: json['time'],
      value: (json['value'] as num).toDouble(),
    );
  }
}
