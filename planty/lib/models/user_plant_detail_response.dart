import 'package:planty/models/env_standard.dart';
import 'package:planty/models/personality.dart';
import 'package:planty/models/plant_info_detail.dart';
import 'package:planty/models/sensor_data.dart';
import 'package:planty/models/user_plant_status.dart';

class UserPlantDetailResponse {
  final int id;
  final String nickname;
  final String imageUrl;
  final DateTime adoptedAt;
  final Personality personality;
  final PlantInfoDetail plantInfo;
  final EnvStandard envStandard;
  final UserPlantStatus? status;
  final SensorData? sensorData;

  UserPlantDetailResponse({
    required this.id,
    required this.nickname,
    required this.imageUrl,
    required this.adoptedAt,
    required this.personality,
    required this.plantInfo,
    required this.envStandard,
    this.status,
    this.sensorData,
  });

  factory UserPlantDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserPlantDetailResponse(
      id: json['id'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
      adoptedAt: DateTime.parse(json['adoptedAt']),
      personality: Personality.fromJson(json['personality']),
      plantInfo: PlantInfoDetail.fromJson(json['plantInfo']),
      envStandard: EnvStandard.fromJson(json['envStandard']),
      status:
          json['status'] != null
              ? UserPlantStatus.fromJson(json['status'])
              : null,
      sensorData:
          json['sensorData'] != null
              ? SensorData.fromJson(json['sensorData'])
              : null,
    );
  }
}
