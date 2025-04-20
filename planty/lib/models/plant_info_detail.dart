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

  // 한글 매핑 메서드
  // 기본 정보
  Map<String, String?> toBasicInfoMap() {
    return {
      '학명': _formatValue(scientificName),
      '영명': _formatValue(englishName),
      '유통명': _formatValue(tradeName),
      '원산지': _formatValue(origin),
      'TIP': _formatValue(careTip),
    };
  }

  // 상세 정보
  Map<String, String?> toDetailInfoMap() {
    return {
      '분류': _formatValue(category),
      '생육형태': _formatValue(growthForm),
      '생장높이(cm)': _formatValue(growthHeight?.toString()),
      '생장너비(cm)': _formatValue(growthWidth?.toString()),
      '실내정원구성': _formatValue(indoorGardenUse),
      '생태형': _formatValue(ecologicalType),
      '잎형태': _formatValue(leafShape),
      '잎무늬': _formatValue(leafPattern),
      '잎색': _formatValue(leafColor),
      '꽃피는 계절': _formatValue(floweringSeason),
      '꽃색': _formatValue(flowerColor),
      '열매맺는 계절': _formatValue(fruitingSeason),
      '열매색': _formatValue(fruitColor),
      '향기': _formatValue(fragrance),
      '번식방법': _formatValue(propagationMethod),
      '번식시기': _formatValue(propagationSeason),
    };
  }

  // 관리 정보
  Map<String, String?> toCareInfoMap() {
    return {
      '관리수준': _formatValue(careLevel),
      '관리요구도': _formatValue(careDifficulty),
      '광요구도': _formatValue(lightRequirement),
      '배치장소': _formatValue(placement),
      '생장속도': _formatValue(growthRate),
      '생육적온': _formatValue(optimalTemperature),
      '겨울최저온도': _formatValue(minWinterTemperature),
      '습도': _formatValue(humidity),
      '비료': _formatValue(fertilizer),
      '토양': _formatValue(soilType),
      '물주기-봄': _formatValue(wateringSpring),
      '물주기-여름': _formatValue(wateringSummer),
      '물주기-가을': _formatValue(wateringAutumn),
      '물주기-겨울': _formatValue(wateringWinter),
      '병충해': _formatValue(pestsDiseases),
    };
  }

  // 기능성 정보
  Map<String, String?> toFunctionInfoMap() {
    return {'기능성 정보': functionalInfo};
  }

  String _formatValue(String? value) {
    return value == null || value.trim().isEmpty ? '-' : value;
  }
}
