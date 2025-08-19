import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/environmentreport.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/line_chart_widget.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class EnvironmentReportScreen extends StatefulWidget {
  final int userPlantId;

  const EnvironmentReportScreen({super.key, required this.userPlantId});

  @override
  State<EnvironmentReportScreen> createState() =>
      _EnvironmentReportScreenState();
}

class _EnvironmentReportScreenState extends State<EnvironmentReportScreen> {
  late Future<EnvironmentReport> reportFuture;
  int selectedIndex = 0; // 0: 온도, 1: 조도, 2: 습도
  final _userPlantService = UserPlantService();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    reportFuture = _userPlantService.fetchEnvironmentReport(
      widget.userPlantId,
      DateFormat('yyyy-MM-dd').format(selectedDate),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        reportFuture = _userPlantService.fetchEnvironmentReport(
          widget.userPlantId,
          DateFormat('yyyy-MM-dd').format(picked),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabLabels = ['온도', '조도', '습도'];
    final unit = ['°C', 'Lux', '%'];
    final recommendedKeys = ['temperature', 'light', 'humidity'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          titleText: "환경 리포트",
        ),
      ),
      body: FutureBuilder<EnvironmentReport>(
        future: reportFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final report = snapshot.data!;
            final sensorDataList = [
              report.temperature,
              report.light,
              report.humidity,
            ];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 식물 이름 & 자동모드 스위치
                  Row(
                    children: [
                      Icon(Icons.local_florist, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        report.plantName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Switch(value: report.autoMode, onChanged: null),
                      const Text('자동관리모드', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 날짜 선택
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ),

                  // 토글버튼
                  Center(
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      isSelected: List.generate(3, (i) => i == selectedIndex),
                      onPressed: (i) => setState(() => selectedIndex = i),
                      selectedColor: Colors.white,
                      fillColor: AppColors.primary,
                      color: Colors.black,
                      children:
                          tabLabels
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 그래프
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 250,
                        child: LineChartWidget(
                          data: sensorDataList[selectedIndex],
                          min:
                              report
                                  .recommended[recommendedKeys[selectedIndex]]!['min']!,
                          max:
                              report
                                  .recommended[recommendedKeys[selectedIndex]]!['max']!,
                          unit: unit[selectedIndex],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 권장 범위
                  Text(
                    '${tabLabels[selectedIndex]} 권장 범위',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.light.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      '${report.recommended[recommendedKeys[selectedIndex]]!['min']} ~ '
                      '${report.recommended[recommendedKeys[selectedIndex]]!['max']} ${unit[selectedIndex]}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
