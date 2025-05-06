import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/screens/home/home_screen.dart';
import 'package:planty/widgets/primary_button.dart';

class RegisterCompleteScreen extends StatelessWidget {
  final String nickname;

  const RegisterCompleteScreen({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_florist, color: AppColors.primary, size: 100),
              const SizedBox(height: 24),
              Text(
                '$nickname 등록 완료!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '이제 홈에서 식물 상태를 확인할 수 있어요.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: '홈으로 가기',
                height: 38,
                fontSize: 13,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
