class UserPlantEditModel {
  final String? nickname;
  final DateTime? adoptedAt;
  final bool? autoControlEnabled;
  final int? personalityId;

  UserPlantEditModel({
    this.nickname,
    this.adoptedAt,
    this.autoControlEnabled,
    this.personalityId,
  });

  factory UserPlantEditModel.fromJson(Map<String, dynamic> json) {
    return UserPlantEditModel(
      nickname: json['nickname'],
      adoptedAt: DateTime.parse(json['adoptedAt']),
      autoControlEnabled: json['autoControlEnabled'],
      personalityId: json['personalityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (nickname != null) 'nickname': nickname,
      if (adoptedAt != null) 'adoptedAt': adoptedAt!.toIso8601String(),
      if (autoControlEnabled != null) 'autoControlEnabled': autoControlEnabled,
      if (personalityId != null) 'personalityId': personalityId,
    };
  }
}
