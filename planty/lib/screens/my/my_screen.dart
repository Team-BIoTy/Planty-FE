import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final String userEmail = "test@test.com";
  final DateTime joinedDate = DateTime(2025, 1, 15); // 예시 가입일

  int get daysTogether {
    final now = DateTime.now();
    return now.difference(joinedDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(trailingType: AppBarTrailingType.notification),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // 프로필 정보
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.light,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "🌱 함께한지 $daysTogether일 째예요!",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 0.5, color: Color(0xFFE5EDD5)),

            // 메뉴 리스트
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem("비밀번호 변경", onTap: () {}),
                  _buildMenuItem("알림 설정", onTap: () {}),
                  _buildMenuItem("IoT 기기 관리", onTap: () {}),
                  _buildMenuItem("탈퇴하기", onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3, onTap: (_) {}),
    );
  }

  Widget _buildMenuItem(String text, {required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            text,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: AppColors.primary),
          onTap: onTap,
        ),
        const Divider(thickness: 0.5, color: Color(0xFFE5EDD5), height: 0),
      ],
    );
  }
}
