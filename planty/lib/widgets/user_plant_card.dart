import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/plant_status_btn.dart';

class UserPlantCard extends StatelessWidget {
  const UserPlantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 식물 이미지 + 이모티콘
                  Stack(
                    children: [
                      // 식물 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/images/planty_logo.png',
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
                            color: Colors.yellow.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '😆',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 15),

                  // 닉네임, 입양일
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '테리',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '함께 한 지 28일째',
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
                              score: 2,
                            ),
                            SizedBox(width: 15),
                            PlantStatusBtn(
                              icon: Icons.wb_sunny_rounded,
                              iconColor: AppColors.grey2,
                              score: 2,
                            ),
                            SizedBox(width: 15),
                            PlantStatusBtn(
                              icon: Icons.water_drop_rounded,
                              iconColor: AppColors.grey2,
                              score: 2,
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
                    '지금 나... 사막에 있는 기분이야 🌵\n물 한 컵만 줘~! 쑥쑥 자라나볼게! 😆💦',
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
