import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/plant_info_detail.dart';
import 'package:planty/services/plant_info_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/detail_info_section.dart';

class PlantDictionaryDetailScreen extends StatefulWidget {
  final int plantId;

  const PlantDictionaryDetailScreen({super.key, required this.plantId});

  @override
  State<PlantDictionaryDetailScreen> createState() =>
      _PlantDictionaryDetailScreenState();
}

class _PlantDictionaryDetailScreenState
    extends State<PlantDictionaryDetailScreen> {
  PlantInfoDetail? _plant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlantDetail();
  }

  Future<void> _fetchPlantDetail() async {
    try {
      final plant = await PlantInfoService().fetchPlantDetail(widget.plantId);
      setState(() {
        _plant = plant;
        _isLoading = false;
      });
    } catch (e) {
      print('에러 발생: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          titleText: '식물 정보',
        ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _plant == null
                ? const Center(child: Text('식물 정보를 불러올 수 없습니다.'))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단: 썸네일 + 이름
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                _plant!.imageUrl ??
                                    'https://nongsaro.go.kr/cms_contents/301/12938_MF_ATTACH_01.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _plant!.commonName ?? '',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    _plant!.englishName ?? '',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 16,
                        color: AppColors.primary.withOpacity(0.5),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 16),
                      // 큰 이미지
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _plant!.imageUrl ??
                                'https://nongsaro.go.kr/cms_contents/301/12938_MF_ATTACH_01.jpg',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        height: 16,
                        color: AppColors.primary.withOpacity(0.5),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 16),
                      // 정보 섹션들
                      DetailInfoSection(
                        title: '기본 정보',
                        infoMap: _plant!.toBasicInfoMap(),
                      ),
                      DetailInfoSection(
                        title: '상세 정보',
                        infoMap: _plant!.toDetailInfoMap(),
                      ),
                      DetailInfoSection(
                        title: '관리 정보',
                        infoMap: _plant!.toCareInfoMap(),
                      ),
                      DetailInfoSection(
                        title: '기능성 정보',
                        infoMap: {'': _plant!.functionalInfo},
                        showKey: false,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
