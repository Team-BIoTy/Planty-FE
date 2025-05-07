class EnvStandard {
  final Range? temperature;
  final Range? light;
  final Range? humidity;

  EnvStandard({this.temperature, this.light, this.humidity});

  factory EnvStandard.fromJson(Map<String, dynamic>? json) {
    if (json == null) return EnvStandard();

    return EnvStandard(
      temperature:
          json['temperature'] != null
              ? Range.fromJson(json['temperature'])
              : null,
      light: json['light'] != null ? Range.fromJson(json['light']) : null,
      humidity:
          json['humidity'] != null ? Range.fromJson(json['humidity']) : null,
    );
  }
}

class Range {
  final int min;
  final int max;

  Range({required this.min, required this.max});

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(min: json['min'] ?? 0, max: json['max'] ?? 0);
  }
}
