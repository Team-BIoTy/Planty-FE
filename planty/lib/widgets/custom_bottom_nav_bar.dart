import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/screens/home_screen.dart';
import 'package:planty/screens/my_screen.dart';
import 'package:planty/screens/plant_dictionary_screen.dart';

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
          _buildNavItem(context, Icons.person, 3, '/my'),
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
      onTap: () {
        if (!isSelected) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      _getScreenByRoute(routeName),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.light,
        size: 28,
      ),
    );
  }

  Widget _getScreenByRoute(String routeName) {
    switch (routeName) {
      case '/home':
        return const HomeScreen();
      case '/plants':
        return const PlantDictionaryScreen();
      case '/chat':
        return const HomeScreen();
      case '/my':
        return const MyScreen();
      default:
        return const HomeScreen();
    }
  }
}
