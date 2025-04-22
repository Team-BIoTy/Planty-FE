import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class DetailInfoSection extends StatelessWidget {
  final String title;
  final Map<String, String?> infoMap;
  final bool showKey;

  const DetailInfoSection({
    super.key,
    required this.title,
    required this.infoMap,
    this.showKey = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 13),

        // 정보 카드
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.light.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children:
                infoMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showKey)
                          SizedBox(
                            width: 90,
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            entry.value?.trim().isNotEmpty == true
                                ? entry.value!
                                : '-',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
        SizedBox(height: 13),
      ],
    );
  }
}
