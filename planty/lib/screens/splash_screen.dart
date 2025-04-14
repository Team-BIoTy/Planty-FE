import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/screens/home_screen.dart';
import 'package:planty/screens/login_screen.dart';

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
    await Future.delayed(Duration(seconds: 3));

    final token = await storage.read(key: 'token');
    final isLoggedIn = token != null && token.isNotEmpty;

    if (isLoggedIn) {
      // [추후] 토큰 유효성 검사 추가
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
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
