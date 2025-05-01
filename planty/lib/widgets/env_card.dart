import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class EnvCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String recommendedLabel;
  final String recommendedValue;
  final String averageLabel;
  final String averageValue;

  const EnvCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.recommendedLabel,
    required this.recommendedValue,
    required this.averageLabel,
    required this.averageValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.light.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: AppColors.primary, size: 25),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      label,
                      style: TextStyle(fontSize: 8, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  recommendedLabel,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  recommendedValue,
                  style: TextStyle(fontSize: 7, color: AppColors.primary),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  averageLabel,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  averageValue,
                  style: TextStyle(fontSize: 7, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
