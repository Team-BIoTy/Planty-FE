import 'package:flutter/material.dart';

class EnvironmentReportScreen extends StatelessWidget {
  final int userPlantId;

  const EnvironmentReportScreen({super.key, required this.userPlantId});

  @override
  Widget build(BuildContext context) {
    // 리포트 화면 구성
    return Scaffold(
      appBar: AppBar(title: Text('환경 리포트')),
      body: Center(child: Text('리포트 내용 표시 예정')),
    );
  }
}
