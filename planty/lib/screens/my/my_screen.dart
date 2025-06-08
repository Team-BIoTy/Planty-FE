import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/screens/onboarding/login_screen.dart';
import 'package:planty/services/auth_service.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final String userEmail = "test@test.com";
  final DateTime joinedDate = DateTime(2025, 1, 15); // 예시 가입일
  final storage = FlutterSecureStorage();
  final authService = AuthService();

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
        child: CustomAppBar(),
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
                  _buildMenuItem("비밀번호 변경", onTap: _showChangePasswordDialog),
                  _buildMenuItem("알림 설정", onTap: () {}),
                  _buildMenuItem("로그아웃", onTap: _logout),
                  _buildMenuItem("탈퇴하기", onTap: _confirmDeleteAccount),
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

  Future<void> _logout() async {
    await storage.delete(key: 'token');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _showChangePasswordDialog() {
    String currentPw = '';
    String newPw = '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '비밀번호 변경',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  obscureText: true,
                  style: TextStyle(color: AppColors.primary),
                  decoration: InputDecoration(
                    labelText: '현재 비밀번호',
                    labelStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => currentPw = value,
                ),
                TextField(
                  obscureText: true,
                  style: TextStyle(color: AppColors.primary),
                  decoration: InputDecoration(
                    labelText: '새 비밀번호',
                    labelStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => newPw = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('취소', style: TextStyle(color: AppColors.primary)),
              ),
              TextButton(
                onPressed: () async {
                  final token = await storage.read(key: 'token');
                  if (token != null) {
                    try {
                      await authService.changePassword(
                        token: token,
                        currentPassword: currentPw,
                        newPassword: newPw,
                      );
                      if (!mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('비밀번호가 변경되었습니다')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Text('변경', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '정말 탈퇴하시겠어요?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            content: Text(
              '모든 정보가 삭제됩니다.',
              style: TextStyle(fontSize: 14, color: AppColors.primary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('취소', style: TextStyle(color: AppColors.primary)),
              ),
              TextButton(
                onPressed: () async {
                  final token = await storage.read(key: 'token');
                  if (token != null) {
                    try {
                      await authService.deleteAccount(token);
                      await storage.delete(key: 'token');
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Text('탈퇴하기', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
