import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class PlantStatusBtn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int score; // 0~3

  const PlantStatusBtn({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 아이콘 버튼
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.grey1,
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
    );
  }
}
