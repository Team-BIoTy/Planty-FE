import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/screens/home_screen.dart';
import 'package:planty/screens/login_screen.dart';
import 'package:planty/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(Duration(seconds: 2));

    final token = await storage.read(key: 'token');
    print('읽은 토큰: $token');

    if (token != null && token.isNotEmpty) {
      final isValid = await AuthService().validToken(token);

      if (isValid) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/planty_logo.png',
              width: 160,
              height: 65,
            ),
            const SizedBox(height: 10),
            Text(
              '당신의 반려 식물과\n함께 하는 힐링 공간',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
