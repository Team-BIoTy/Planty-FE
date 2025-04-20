class PlantInfoDetail {
  final int? id;
  final String? imageUrl;
  final String? commonName;

  // 기본 정보
  final String? scientificName;
  final String? englishName;
  final String? tradeName;
  final String? familyName;
  final String? origin;
  final String? careTip;

  // 상세 정보
  final String? category;
  final String? growthForm;
  final int? growthHeight;
  final int? growthWidth;
  final String? indoorGardenUse;
  final String? ecologicalType;
  final String? leafShape;
  final String? leafPattern;
  final String? leafColor;

  final String? floweringSeason;
  final String? flowerColor;
  final String? fruitingSeason;
  final String? fruitColor;
  final String? fragrance;
  final String? propagationMethod;
  final String? propagationSeason;

  // 관리 정보
  final String? careLevel;
  final String? careDifficulty;
  final String? lightRequirement;
  final String? placement;
  final String? growthRate;
  final String? optimalTemperature;
  final String? minWinterTemperature;
  final String? humidity;
  final String? fertilizer;
  final String? soilType;

  final String? wateringSpring;
  final String? wateringSummer;
  final String? wateringAutumn;
  final String? wateringWinter;
  final String? pestsDiseases;

  // 기능성 정보
  final String? functionalInfo;

  PlantInfoDetail({
    this.id,
    this.imageUrl,
    this.commonName,
    this.scientificName,
    this.englishName,
    this.tradeName,
    this.familyName,
    this.origin,
    this.careTip,
    this.category,
    this.growthForm,
    this.growthHeight,
    this.growthWidth,
    this.indoorGardenUse,
    this.ecologicalType,
    this.leafShape,
    this.leafPattern,
    this.leafColor,
    this.floweringSeason,
    this.flowerColor,
    this.fruitingSeason,
    this.fruitColor,
    this.fragrance,
    this.propagationMethod,
    this.propagationSeason,
    this.careLevel,
    this.careDifficulty,
    this.lightRequirement,
    this.placement,
    this.growthRate,
    this.optimalTemperature,
    this.minWinterTemperature,
    this.humidity,
    this.fertilizer,
    this.soilType,
    this.wateringSpring,
    this.wateringSummer,
    this.wateringAutumn,
    this.wateringWinter,
    this.pestsDiseases,
    this.functionalInfo,
  });

  factory PlantInfoDetail.fromJson(Map<String, dynamic> json) {
    return PlantInfoDetail(
      id: json['id'],
      imageUrl: json['imageUrl'],
      commonName: json['commonName'],
      scientificName: json['scientificName'],
      englishName: json['englishName'],
      tradeName: json['tradeName'],
      familyName: json['familyName'],
      origin: json['origin'],
      careTip: json['careTip'],
      category: json['category'],
      growthForm: json['growthForm'],
      growthHeight: json['growthHeight'],
      growthWidth: json['growthWidth'],
      indoorGardenUse: json['indoorGardenUse'],
      ecologicalType: json['ecologicalType'],
      leafShape: json['leafShape'],
      leafPattern: json['leafPattern'],
      leafColor: json['leafColor'],
      floweringSeason: json['floweringSeason'],
      flowerColor: json['flowerColor'],
      fruitingSeason: json['fruitingSeason'],
      fruitColor: json['fruitColor'],
      fragrance: json['fragrance'],
      propagationMethod: json['propagationMethod'],
      propagationSeason: json['propagationSeason'],
      careLevel: json['careLevel'],
      careDifficulty: json['careDifficulty'],
      lightRequirement: json['lightRequirement'],
      placement: json['placement'],
      growthRate: json['growthRate'],
      optimalTemperature: json['optimalTemperature'],
      minWinterTemperature: json['minWinterTemperature'],
      humidity: json['humidity'],
      fertilizer: json['fertilizer'],
      soilType: json['soilType'],
      wateringSpring: json['wateringSpring'],
      wateringSummer: json['wateringSummer'],
      wateringAutumn: json['wateringAutumn'],
      wateringWinter: json['wateringWinter'],
      pestsDiseases: json['pestsDiseases'],
      functionalInfo: json['functionalInfo'],
    );
  }
}
