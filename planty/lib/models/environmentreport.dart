import 'package:planty/models/sensor_data_point.dart';

class EnvironmentReport {
  final String plantName;
  final bool autoMode;
  final List<SensorDataPoint> temperature;
  final List<SensorDataPoint> light;
  final List<SensorDataPoint> humidity;
  final Map<String, Map<String, double>> recommended;

  EnvironmentReport({
    required this.plantName,
    required this.autoMode,
    required this.temperature,
    required this.light,
    required this.humidity,
    required this.recommended,
  });

  factory EnvironmentReport.fromJson(Map<String, dynamic> json) {
    List<SensorDataPoint> parsePoints(String key) =>
        (json[key] as List).map((e) => SensorDataPoint.fromJson(e)).toList();

    Map<String, Map<String, double>> parseRecommended(
      Map<String, dynamic> input,
    ) {
      return input.map((key, value) {
        final map = value as Map<String, dynamic>;
        return MapEntry(key, {
          'min': (map['min'] as num).toDouble(),
          'max': (map['max'] as num).toDouble(),
        });
      });
    }

    return EnvironmentReport(
      plantName: json['plantName'],
      autoMode: json['autoMode'],
      temperature: parsePoints('temperature'),
      light: parsePoints('light'),
      humidity: parsePoints('humidity'),
      recommended: parseRecommended(json['recommended']),
    );
  }
}
