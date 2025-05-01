import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/screens/home/home_screen.dart';
import 'package:planty/screens/onboarding/signup_screen.dart';
import 'package:planty/widgets/primary_button.dart';
import 'package:planty/services/auth_service.dart';
import 'package:planty/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _stoarge = const FlutterSecureStorage();

  bool _isLoading = false;

  // 사용자가 입력한 이메일과 비밀번호를 가져옴
  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 입력 유효성 체크
    if (email.isEmpty || password.isEmpty) {
      _showError('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthService().login(email, password);
      await _stoarge.write(key: 'token', value: token);
      print('로그인 성공, 토큰: $token');
      if (!mounted) return; // context 보호
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      _showError('로그인에 실패했습니다. ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('오류'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '로그인  ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(controller: _emailController, label: '이메일 입력'),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                label: '비밀번호 입력',
                obscureText: true,
              ),
              SizedBox(height: 20),
              PrimaryButton(
                onPressed: _login,
                label: '로그인',
                isLoading: _isLoading,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text(
                  '아직 회원이 아니신가요? 회원가입',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
