import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/user_plant_summary_response.dart';
import 'package:planty/screens/home/notification_screen.dart';
import 'package:planty/screens/register_plant/plant_list_screen.dart';
import 'package:planty/screens/home/user_plant_detail_screen.dart';
import 'package:planty/services/notification_service.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';
import 'package:planty/widgets/user_plant_card.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserPlantSummaryResponse> _plants = [];
  bool _isLoading = true;
  Timer? _pollingTimer;
  bool _hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
    _startPolling();
    _checkUnreadNotifications();
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

  Future<void> _checkUnreadNotifications() async {
    try {
      final notifications =
          await NotificationService().fetchNotificationsFromJwt();
      final hasUnread = notifications.any((noti) => !noti.isRead);
      if (mounted) {
        setState(() {
          _hasUnreadNotifications = hasUnread;
        });
      }
    } catch (e) {
      print('알림 조회 중 오류 발생: $e');
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchPlants(),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); // memory leak 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단바
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          trailingType: AppBarTrailingType.notification,
          showUnreadDot: _hasUnreadNotifications,
          onNotificationTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            ).then((value) {
              if (value == true) {
                setState(() {
                  _hasUnreadNotifications = false;
                });
              } else {
                _checkUnreadNotifications();
              }
            });
          },
        ),
      ),

      // 바디
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PlantListScreen(),
                                ),
                              );
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 식물 카드 or 빈 메시지
                    if (_plants.isEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            '등록된 식물이 없습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._plants.map(
                        (plant) => UserPlantCard(
                          plant: plant,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => UserPlantDetailScreen(
                                      userPlantId: plant.userPlantId,
                                    ),
                              ),
                            );

                            // 삭제된 경우 새로고침
                            if (result == true) {
                              setState(() => _isLoading = true);
                              await _fetchPlants();
                            }
                          },
                        ),
                      ),
                  ],
                ),
      ),

      // 하단바
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: (_) {}),
    );
  }
}
