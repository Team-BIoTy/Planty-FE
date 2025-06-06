import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
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
  String _searchQuery = '';

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

  List<PlantInfo> _filteredPlantList() {
    if (_searchQuery.isEmpty) return _plantsList;
    return _plantsList.where((plant) {
      final query = _searchQuery.toLowerCase();
      return plant.commonName.toLowerCase().contains(query) ||
          plant.englishName.toLowerCase().contains(query);
    }).toList();
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
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '학명, 키워드로 검색하세요',
                            hintStyle: TextStyle(
                              color: AppColors.primary.withOpacity(0.8),
                              fontSize: 15,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => _searchQuery = value);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          _filteredPlantList().isEmpty
                              ? const Center(child: Text('검색 결과가 없습니다.'))
                              : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: ListView.builder(
                                  itemCount: _filteredPlantList().length,
                                  itemBuilder: (context, index) {
                                    final plant = _filteredPlantList()[index];
                                    return GestureDetector(
                                      onTap: () {
                                        print('눌린 식물 ID: ${plant.id}');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => PlantDetailScreen(
                                                  plantId: plant.id,
                                                ),
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
                  ],
                ),
      ),
    );
  }
}
