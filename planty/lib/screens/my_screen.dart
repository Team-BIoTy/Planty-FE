import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/screens/login_screen.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단바
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(trailingType: AppBarTrailingType.notification),
      ),

      // 바디
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final storage = FlutterSecureStorage();
                await storage.delete(key: 'token');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),

      // 하단바
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3, onTap: (_) {}),
    );
  }
}
