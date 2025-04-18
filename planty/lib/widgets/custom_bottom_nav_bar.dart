import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.light, width: 1)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home_filled, 0, '/home'),
          _buildNavItem(context, Icons.eco_rounded, 1, '/plants'),
          _buildNavItem(context, Icons.forum_rounded, 2, '/chat'),
          _buildNavItem(context, Icons.person, 3, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    int index,
    String routeName,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, routeName),
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.light,
        size: 28,
      ),
    );
  }
}
