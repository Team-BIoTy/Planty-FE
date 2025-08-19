import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:planty/models/sensor_data_point.dart';

class LineChartWidget extends StatelessWidget {
  final List<SensorDataPoint> data;
  final double min;
  final double max;
  final String unit;

  const LineChartWidget({
    super.key,
    required this.data,
    required this.min,
    required this.max,
    required this.unit,
  });

  List<FlSpot> get spots =>
      data.map((e) => FlSpot(e.hour.toDouble(), e.value.toDouble())).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 1200, // 넉넉하게 확보 (24시간 기준)
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 23,
              minY: 0,
              maxY: max + (max - min) * 0.5 + 15,
              backgroundColor: Colors.transparent,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                verticalInterval: 1,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                getDrawingVerticalLine:
                    (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget:
                        (value, meta) => Text(
                          '${value.toInt()}시',
                          style: const TextStyle(fontSize: 10),
                        ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget:
                        (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        ),
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black12),
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.3),
                  ),
                  dotData: FlDotData(show: false),
                  spots: spots,
                ),
              ],
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: min,
                    color: Colors.green,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  HorizontalLine(
                    y: max,
                    color: Colors.green,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
