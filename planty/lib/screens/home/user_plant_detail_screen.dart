import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/user_plant_detail_response.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/detail_info_section.dart';
import 'package:planty/widgets/env_card.dart';
import 'package:planty/widgets/primary_button.dart';

class UserPlantDetailScreen extends StatefulWidget {
  final int userPlantId;

  const UserPlantDetailScreen({super.key, required this.userPlantId});

  @override
  State<UserPlantDetailScreen> createState() => _UserPlantDetailScreenState();
}

class _UserPlantDetailScreenState extends State<UserPlantDetailScreen> {
  bool _isLoading = true;
  UserPlantDetailResponse? _plantDetail;

  @override
  void initState() {
    super.initState();
    _fetchDeatil();
  }

  Future<void> _fetchDeatil() async {
    try {
      final detail = await UserPlantService().fetchUserPlantDetail(
        widget.userPlantId,
      );
      setState(() {
        _plantDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      print('에러 발생: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatRange(int? min, int? max, {String unit = ''}) {
      if (min == null || max == null) return '-';
      return '$min$unit ~ $max$unit';
    }

    String formatValue(dynamic value, {String unit = ''}) {
      if (value == null) return '-';
      return '${value.round()}$unit'; // int형으로 처리
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          titleText: "상세 리포트",
          trailingType: AppBarTrailingType.menu,
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _plantDetail == null
              ? const Center(child: Text("정보를 불러올 수 없습니다."))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. 식물 카드
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.light.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              // 식물 이미지
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  _plantDetail!.imageUrl,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // 이모티콘
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _hexToColor(
                                      _plantDetail!.personality.color,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _plantDetail!.personality.emoji,
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 20),

                          // 정보 + 버튼
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 닉네임
                                Text(
                                  _plantDetail!.nickname,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // 식물명
                                Text(
                                  _plantDetail!.plantInfo.commonName ?? "-",
                                  style: TextStyle(
                                    color: AppColors.grey3,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // 영문명
                                Text(
                                  _plantDetail!.plantInfo.scientificName ?? "",
                                  style: TextStyle(
                                    color: AppColors.grey3,
                                    fontSize: 11,
                                  ),
                                ),

                                const SizedBox(height: 5),
                                Divider(
                                  height: 16,
                                  color: AppColors.primary.withOpacity(0.5),
                                  thickness: 0.5,
                                ),
                                const SizedBox(height: 5),

                                // 날짜
                                Text(
                                  '함께 한 지 ${DateTime.now().difference(_plantDetail!.adoptedAt).inDays}일째',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // 챗봇 버튼
                                PrimaryButton(
                                  onPressed: () => {},
                                  label: "테리와 대화하기",
                                  width: 110,
                                  height: 33,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // 2. 실시간 환경
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "실시간 환경",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              _plantDetail?.sensorData?.recordedAt != null
                                  ? DateFormat(
                                    'MM월 dd일 HH:mm 업데이트',
                                  ).format(_plantDetail!.sensorData!.recordedAt)
                                  : "정보 없음",
                              style: TextStyle(
                                fontSize: 8,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            EnvCard(
                              icon: Icons.thermostat,
                              label: '환경 온도',
                              value: formatValue(
                                _plantDetail?.sensorData?.temperature,
                                unit: '°C',
                              ),
                              recommendedLabel: '권장 온도',
                              recommendedValue: formatRange(
                                _plantDetail?.envStandard.temperature?.min,
                                _plantDetail?.envStandard.temperature?.max,
                                unit: '°C',
                              ),
                              averageLabel: '평균 온도',
                              averageValue: formatValue(
                                _plantDetail?.status?.temperatureScore,
                                unit: '°C',
                              ),
                            ),
                            EnvCard(
                              icon: Icons.wb_sunny_outlined,
                              label: '환경 조도',
                              value: formatValue(
                                _plantDetail?.sensorData?.light,
                                unit: 'Lux',
                              ),
                              recommendedLabel: '권장 조도',
                              recommendedValue: formatRange(
                                _plantDetail?.envStandard.light?.min,
                                _plantDetail?.envStandard.light?.max,
                                unit: 'Lux',
                              ),
                              averageLabel: '평균 조도',
                              averageValue: formatValue(
                                _plantDetail?.status?.lightScore,
                                unit: 'Lux',
                              ),
                            ),
                            EnvCard(
                              icon: Icons.water_drop,
                              label: '흙 수분',
                              value: formatValue(
                                _plantDetail?.sensorData?.humidity,
                                unit: '%',
                              ),
                              recommendedLabel: '권장 수분',
                              recommendedValue: formatRange(
                                _plantDetail?.envStandard.humidity?.min,
                                _plantDetail?.envStandard.humidity?.max,
                                unit: '%',
                              ),
                              averageLabel: '평균 수분',
                              averageValue: formatValue(
                                _plantDetail?.status?.humidityScore,
                                unit: '%',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),

                    const SizedBox(height: 5),
                    Divider(
                      height: 16,
                      color: AppColors.primary.withOpacity(0.5),
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 5),

                    // 3. 식물 도감
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        Text(
                          "식물 도감",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 13),
                        DetailInfoSection(
                          title: '기본 정보',
                          size: 12,
                          infoMap: _plantDetail!.plantInfo.toBasicInfoMap(),
                        ),

                        DetailInfoSection(
                          title: '상세 정보',
                          size: 12,
                          infoMap: _plantDetail!.plantInfo.toDetailInfoMap(),
                        ),

                        DetailInfoSection(
                          title: '관리 정보',
                          size: 12,
                          infoMap: _plantDetail!.plantInfo.toCareInfoMap(),
                        ),

                        DetailInfoSection(
                          title: '기능성 정보',
                          size: 12,
                          infoMap: {'': _plantDetail!.plantInfo.functionalInfo},
                          showKey: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // 불투명도 100% (alpha)
  }
  return Color(int.parse(hex, radix: 16));
}
