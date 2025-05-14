import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/services/iot_device_service.dart';

class PlantStatusBtn extends StatelessWidget {
  final IconData icon;
  final int score; // 0~3
  final String commandType; // 'WATER', 'FAN', 'LIGHT'
  final int userPlantId;

  const PlantStatusBtn({
    super.key,
    required this.icon,
    required this.score,
    required this.commandType,
    required this.userPlantId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = (score == 0);
    final Color backgroundColor = isActive ? AppColors.light : AppColors.grey1;
    final Color iconColor = isActive ? AppColors.primary : AppColors.grey2;

    return GestureDetector(
      onTap:
          isActive
              ? () async {
                try {
                  await IotDeviceService().sendCommandToDevice(
                    userPlantId: userPlantId,
                    type: commandType,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$commandType 명령 전송 완료!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('명령 전송 실패: $e')));
                }
              }
              : null,

      child: Column(
        children: [
          // 아이콘 버튼
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 25)),
          ),
          const SizedBox(height: 1),
          // 하트 점수 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < score ? Icons.favorite : Icons.favorite_border,
                color: AppColors.primary,
                size: 18,
              );
            }),
          ),
        ],
      ),
    );
  }
}
