class PlantInfo {
  final int? id;
  final String commonName;
  final String englishName;
  final String? imageUrl;

  PlantInfo({
    required this.id,
    required this.commonName,
    required this.englishName,
    required this.imageUrl,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      id: json['id'] as int?,
      commonName: json['commonName'],
      englishName: json['englishName'],
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
