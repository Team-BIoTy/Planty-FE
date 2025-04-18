import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/user_plant_summary_response.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';
import 'package:planty/widgets/user_plant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserPlantSummaryResponse> _plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    try {
      final plants = await UserPlantService().fetchUserPlants();
      setState(() {
        _plants = plants;
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
      // 상단바
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leading: Image.asset('assets/images/planty_logo.png', height: 30),
          trailing: Icon(
            Icons.notifications_outlined,
            color: AppColors.primary,
          ),
        ),
      ),

      // 바디
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _plants.isEmpty
                ? const Center(child: Text('등록된 식물이 없습니다.'))
                : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      // 상단 UI
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '나의 정원',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '총 ${_plants.length}개',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // 식물 등록 버튼
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_rounded,
                                    color: AppColors.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '식물 등록',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 식물 카드들
                    ..._plants.map((plant) => UserPlantCard(plant: plant)),
                  ],
                ),
      ),

      // 하단바
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: (_) {}),
    );
  }
}
