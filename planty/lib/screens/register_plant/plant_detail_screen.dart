import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/plant_info_detail.dart';
import 'package:planty/services/plant_info_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class PlantDetailScreen extends StatefulWidget {
  final int? plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  PlantInfoDetail? _plant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlantDetail();
  }

  Future<void> _fetchPlantDetail() async {
    try {
      final plant = await PlantInfoService().fetchPlantDetail(
        widget.plantId ?? 0,
      );
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
          titleText: '상세 정보',
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
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _plant!.imageUrl ??
                                'https://nongsaro.go.kr/cms_contents/301/12938_MF_ATTACH_01.jpg',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _plant!.commonName ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        _plant!.englishName ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
