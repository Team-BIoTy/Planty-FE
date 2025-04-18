import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? leading; // 좌측 (로고 or 뒤로가기)
  final Widget? center; // 중앙 (제목)
  final Widget? trailing; // 우측 (알림 or 메뉴)

  const CustomAppBar({super.key, this.leading, this.center, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.light, width: 1),
              ),
              color: Colors.white,
            ),
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 좌측
                SizedBox(width: 70, child: leading ?? const SizedBox()),
                // 중앙
                Expanded(child: Center(child: center ?? const SizedBox())),
                // 우측
                SizedBox(width: 40, child: trailing ?? const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
