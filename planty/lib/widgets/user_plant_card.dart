import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/user_plant_summary_response.dart';
import 'package:planty/widgets/plant_status_btn.dart';

class UserPlantCard extends StatelessWidget {
  final UserPlantSummaryResponse plant;
  final VoidCallback? onTap;

  const UserPlantCard({super.key, required this.plant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = plant.status;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // 상단 Row: 식물 이미지, 이모티콘 + 닉네임, 날짜 + 상태 버튼
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 식물 이미지 + 이모티콘
                    Stack(
                      children: [
                        // 식물 이미지
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            plant.imageUrl,
                            width: 127,
                            height: 127,
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
                              color: _hexToColor(plant.personality.color),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                plant.personality.emoji,
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 15),

                    // 닉네임, 날짜 + 상태 버튼
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 닉네임
                          Text(
                            plant.nickname,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // 날짜
                          Text(
                            '함께 한 지 ${DateTime.now().difference(plant.adoptedAt).inDays + 1}일째',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 15),

                          // 식물 인터랙션 버튼 + 상태 하트
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PlantStatusBtn(
                                icon: Icons.thermostat_rounded,
                                iconColor: AppColors.grey2,
                                score: status?.temperatureScore ?? 0,
                              ),
                              SizedBox(width: 15),
                              PlantStatusBtn(
                                icon: Icons.wb_sunny_rounded,
                                iconColor: AppColors.grey2,
                                score: status?.lightScore ?? 0,
                              ),
                              SizedBox(width: 15),
                              PlantStatusBtn(
                                icon: Icons.water_drop_rounded,
                                iconColor: AppColors.grey2,
                                score: status?.humidityScore ?? 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // 상태 메시지
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.light.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      status?.message ?? '-',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
