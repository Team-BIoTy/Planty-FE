import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class PlantInfoCard extends StatelessWidget {
  final String? imageUrl;
  final String commonName;
  final String englishName;

  const PlantInfoCard({
    super.key,
    required this.imageUrl,
    required this.commonName,
    required this.englishName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 식물 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              imageUrl ??
                  "https://nongsaro.go.kr/cms_contents/301/12938_MF_ATTACH_01.jpg",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 20),
          // 식물 이름, 영문명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commonName,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  englishName,
                  style: TextStyle(color: AppColors.primary, fontSize: 11),
                ),
              ],
            ),
          ),
          // 화살표
          Container(
            alignment: Alignment(1, 0),
            width: 60,
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}
