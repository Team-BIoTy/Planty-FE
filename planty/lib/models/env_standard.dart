class EnvStandard {
  final Range temperature;
  final Range light;
  final Range humidity;

  EnvStandard({
    required this.temperature,
    required this.light,
    required this.humidity,
  });

  factory EnvStandard.fromJson(Map<String, dynamic> json) {
    return EnvStandard(
      temperature: Range.fromJson(json['temperature']),
      light: Range.fromJson(json['light']),
      humidity: Range.fromJson(json['humidity']),
    );
  }
}

class Range {
  final int min;
  final int max;

  Range({required this.min, required this.max});

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(min: json['min'], max: json['max']);
  }
}
