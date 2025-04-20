import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/primary_button.dart';

class PlantInputScreen extends StatelessWidget {
  final int plantId;

  const PlantInputScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          titleText: '정보 입력',
        ),
      ),
      body: Center(child: Text('선택한 plantId: $plantId')),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.light, width: 1)),
          color: Colors.white,
        ),

        child: Center(
          child: PrimaryButton(
            label: '등록하기',
            onPressed: () => {},
            width: 350,
            height: 38,
            fontSize: 13,
            icon: const Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
