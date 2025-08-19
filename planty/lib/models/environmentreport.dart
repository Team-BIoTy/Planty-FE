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

    return EnvironmentReport(
      plantName: json['plantName'],
      autoMode: json['autoMode'],
      temperature: parsePoints('temperature'),
      light: parsePoints('light'),
      humidity: parsePoints('humidity'),
      recommended: Map<String, Map<String, double>>.from(
        json['recommended'].map(
          (key, value) => MapEntry(key, {
            'min': value['min'].toDouble(),
            'max': value['max'].toDouble(),
          }),
        ),
      ),
    );
  }
}
