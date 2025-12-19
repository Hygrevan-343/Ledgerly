import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/chart_data.dart';
import '../utils/constants.dart';

class SpendingChart extends StatelessWidget {
  final List<ChartData> data;
  final double height;

  const SpendingChart({
    super.key,
    required this.data,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: _getMinY(),
          maxY: _getMaxY(),
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: _buildBottomTitles,
                interval: 1,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(),
              isCurved: true,
              color: AppConstants.primaryTeal,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: AppConstants.primaryTeal,
                  strokeWidth: 2,
                  strokeColor: AppConstants.backgroundDark,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppConstants.primaryTeal.withOpacity(0.3),
                    AppConstants.primaryTeal.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    return data
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    if (value.toInt() >= 0 && value.toInt() < data.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          data[value.toInt()].label,
          style: const TextStyle(
            color: AppConstants.textSecondary,
            fontSize: AppConstants.fontSizeS,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  double _getMinY() {
    if (data.isEmpty) return 0;
    final values = data.map((e) => e.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    return (min * 0.8); // Add some padding
  }

  double _getMaxY() {
    if (data.isEmpty) return 100;
    final values = data.map((e) => e.value).toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max * 1.2); // Add some padding
  }
} 