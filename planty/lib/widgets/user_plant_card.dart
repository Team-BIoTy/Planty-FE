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
    final imageSize = screenWidth * 0.28 > 120 ? 120.0 : screenWidth * 0.28;

    String formatCheckedAt(DateTime? dt) {
      if (dt == null) return '정보 없음';
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return '방금 전';
      if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
      if (diff.inHours < 24) return '${diff.inHours}시간 전';
      return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 식물 이미지 + 이모티콘
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        plant.imageUrl,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: imageSize * 0.3,
                        height: imageSize * 0.3,
                        decoration: BoxDecoration(
                          color: _hexToColor(plant.personality.color),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            plant.personality.emoji,
                            style: TextStyle(fontSize: imageSize * 0.18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 15),

                // 닉네임, 날짜 + 상태 버튼
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.nickname,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '함께 한 지 ${DateTime.now().difference(plant.adoptedAt).inDays + 1}일째',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PlantStatusBtn(
                              icon: Icons.thermostat_rounded,
                              score: status!.temperatureScore,
                              commandType: 'FAN',
                              userPlantId: plant.userPlantId,
                              runningCommandId:
                                  plant.runningCommands['FAN']?.toInt(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PlantStatusBtn(
                              icon: Icons.wb_sunny_rounded,
                              score: status.lightScore,
                              commandType: 'LIGHT',
                              userPlantId: plant.userPlantId,
                              runningCommandId:
                                  plant.runningCommands['LIGHT']?.toInt(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PlantStatusBtn(
                              icon: Icons.water_drop_rounded,
                              score: status.humidityScore,
                              commandType: 'WATER',
                              userPlantId: plant.userPlantId,
                              runningCommandId:
                                  plant.runningCommands['WATER']?.toInt(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 상태 메시지
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.light.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                status.message,
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 5),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '🌱 최근 상태 확인: ${formatCheckedAt(status.checkedAt)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
