import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/primary_button.dart';

class RegisterBottomBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final bool showIcon;

  const RegisterBottomBar({
    super.key,
    required this.onPressed,
    this.label = '등록하기',
    this.icon,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIcon = const Icon(
      Icons.add_circle_rounded,
      color: Colors.white,
      size: 16,
    );

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 70,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.light, width: 1)),
          color: Colors.white,
        ),
        child: Center(
          child: PrimaryButton(
            label: label,
            onPressed: onPressed,
            width: 350,
            height: 38,
            fontSize: 13,
            icon: showIcon ? (icon ?? defaultIcon) : null,
          ),
        ),
      ),
    );
  }
}
