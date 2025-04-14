import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/services/auth_service.dart';
import 'package:planty/widgets/custom_text_field.dart';
import 'package:planty/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;

  void _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('모든 필드를 입력해주세요.');
      return;
    }

    if (password != confirmPassword) {
      _showError('비밀번호가 일치하지 않습니다.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().signup(email, password);
      _showSuccess('회원가입이 완료되었습니다. 로그인해주세요.');
    } catch (e) {
      _showError('회원가입 실패: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('완료'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // 로그인 화면으로 복귀
                },
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '회원가입',
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
              CustomTextField(
                controller: _confirmController,
                label: '비밀번호 확인',
                obscureText: true,
              ),
              SizedBox(height: 20),
              PrimaryButton(
                onPressed: _signup,
                label: '회원가입',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
