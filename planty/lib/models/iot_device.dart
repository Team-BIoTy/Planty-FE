class IotDevice {
  final int id;
  final String deviceSerial;
  final String model;
  final String status;

  IotDevice({
    required this.id,
    required this.deviceSerial,
    required this.model,
    required this.status,
  });

  factory IotDevice.fromJson(Map<String, dynamic> json) {
    return IotDevice(
      id: json['id'],
      deviceSerial: json['deviceSerial'],
      model: json['model'],
      status: json['status'],
    );
  }
}
