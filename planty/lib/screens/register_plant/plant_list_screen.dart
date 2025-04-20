import 'package:flutter/material.dart';
import 'package:planty/models/plant_info.dart';
import 'package:planty/screens/register_plant/plant_detail_screen.dart';
import 'package:planty/services/plant_info_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/plant_info_card.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  List<PlantInfo> _plantsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlantList();
  }

  Future<void> _fetchPlantList() async {
    try {
      final plants = await PlantInfoService().fetchPlantLists();
      setState(() {
        _plantsList = plants;
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
          titleText: '식물 등록',
        ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _plantsList.isEmpty
                ? const Center(child: Text('등록 가능한 식물이 없습니다.'))
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: _plantsList.length,
                    itemBuilder: (context, index) {
                      final plant = _plantsList[index];
                      return GestureDetector(
                        onTap: () {
                          print('눌린 식물 ID: ${plant.id}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PlantDetailScreen(plantId: plant.id),
                            ),
                          );
                        },
                        child: PlantInfoCard(
                          imageUrl: plant.imageUrl,
                          commonName: plant.commonName,
                          englishName: plant.englishName,
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
