import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

enum AppBarLeadingType { none, back, logo }

enum AppBarTrailingType { none, notification, menu }

class CustomAppBar extends StatelessWidget {
  final AppBarLeadingType leadingType;
  final String? titleText;
  final AppBarTrailingType trailingType;
  final Widget? customTrailingWidget;
  final bool showUnreadDot;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    this.leadingType = AppBarLeadingType.logo,
    this.titleText,
    this.trailingType = AppBarTrailingType.none,
    this.customTrailingWidget,
    this.showUnreadDot = false,
    this.onNotificationTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    // 좌측 leading 처리
    Widget leadingWidget;
    switch (leadingType) {
      case AppBarLeadingType.logo:
        leadingWidget = Image.asset(
          'assets/images/planty_logo.png',
          height: 30,
        );
        break;
      case AppBarLeadingType.back:
        leadingWidget = IconButton(
          onPressed: onBackTap ?? () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
        );
        break;
      case AppBarLeadingType.none:
        leadingWidget = const SizedBox();
        break;
    }

    // 우측 trailing 처리
    Widget trailingWidget;
    switch (trailingType) {
      case AppBarTrailingType.notification:
        trailingWidget = Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
              ),
              onPressed: onNotificationTap,
            ),
            if (showUnreadDot)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
        break;

      case AppBarTrailingType.menu:
        trailingWidget =
            customTrailingWidget ??
            Icon(Icons.more_vert_rounded, color: AppColors.primary);
        break;
      case AppBarTrailingType.none:
        trailingWidget = const SizedBox();
        break;
    }

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
                SizedBox(width: 70, child: leadingWidget),
                // 중앙
                Expanded(
                  child: Center(
                    child:
                        titleText != null
                            ? Text(
                              titleText!,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            )
                            : const SizedBox(),
                  ),
                ),
                // 우측
                SizedBox(width: 40, child: trailingWidget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
