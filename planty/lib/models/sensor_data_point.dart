class SensorDataPoint {
  final String time;
  final double value;

  SensorDataPoint({required this.time, required this.value});

  /// 시간 문자열로부터 시(hour) 정수 추출
  int get hour => int.parse(time.split(":")[0]);

  factory SensorDataPoint.fromJson(Map<String, dynamic> json) {
    return SensorDataPoint(
      time: json['time'],
      value: (json['value'] as num).toDouble(),
    );
  }
}
