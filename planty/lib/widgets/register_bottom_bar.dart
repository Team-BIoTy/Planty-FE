import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/primary_button.dart';

class RegisterBottomBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final bool showIcon;

  final VoidCallback? secondaryOnPressed;
  final String? secondaryLabel;
  final bool showSecondaryButton;

  const RegisterBottomBar({
    super.key,
    required this.onPressed,
    this.label = '등록하기',
    this.icon,
    this.showIcon = true,
    this.secondaryOnPressed,
    this.secondaryLabel,
    this.showSecondaryButton = false,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showSecondaryButton && secondaryOnPressed != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: PrimaryButton(
                  label: secondaryLabel ?? '취소',
                  onPressed: secondaryOnPressed!,
                  width: 130,
                  height: 38,
                  fontSize: 13,
                  color: AppColors.grey3,
                ),
              ),
            PrimaryButton(
              label: label,
              onPressed: onPressed,
              width: showSecondaryButton ? 180 : 300,
              height: 38,
              fontSize: 13,
              icon: showIcon ? (icon ?? defaultIcon) : null,
            ),
          ],
        ),
      ),
    );
  }
}
