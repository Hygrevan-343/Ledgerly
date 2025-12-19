import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpenseTrendChartWidget extends StatefulWidget {
  final String selectedRange;

  const ExpenseTrendChartWidget({
    Key? key,
    required this.selectedRange,
  }) : super(key: key);

  @override
  State<ExpenseTrendChartWidget> createState() =>
      _ExpenseTrendChartWidgetState();
}

class _ExpenseTrendChartWidgetState extends State<ExpenseTrendChartWidget> {
  int? touchedIndex;

  List<FlSpot> _getChartData() {
    switch (widget.selectedRange) {
      case 'Week':
        return [
          const FlSpot(0, 450),
          const FlSpot(1, 320),
          const FlSpot(2, 680),
          const FlSpot(3, 290),
          const FlSpot(4, 520),
          const FlSpot(5, 780),
          const FlSpot(6, 410),
        ];
      case 'Month':
        return [
          const FlSpot(0, 1200),
          const FlSpot(1, 980),
          const FlSpot(2, 1450),
          const FlSpot(3, 1100),
          const FlSpot(4, 1680),
          const FlSpot(5, 1320),
          const FlSpot(6, 1890),
          const FlSpot(7, 1560),
        ];
      case 'Quarter':
        return [
          const FlSpot(0, 4200),
          const FlSpot(1, 3800),
          const FlSpot(2, 4650),
          const FlSpot(3, 4100),
          const FlSpot(4, 5200),
          const FlSpot(5, 4800),
          const FlSpot(6, 5500),
          const FlSpot(7, 5100),
          const FlSpot(8, 5800),
          const FlSpot(9, 5300),
          const FlSpot(10, 6100),
          const FlSpot(11, 5700),
        ];
      default:
        return [
          const FlSpot(0, 1200),
          const FlSpot(1, 980),
          const FlSpot(2, 1450),
          const FlSpot(3, 1100),
          const FlSpot(4, 1680),
          const FlSpot(5, 1320),
          const FlSpot(6, 1890),
          const FlSpot(7, 1560),
        ];
    }
  }

  String _getXAxisLabel(double value) {
    switch (widget.selectedRange) {
      case 'Week':
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return value.toInt() < days.length ? days[value.toInt()] : '';
      case 'Month':
        return 'W${(value.toInt() + 1)}';
      case 'Quarter':
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return value.toInt() < months.length ? months[value.toInt()] : '';
      default:
        return 'W${(value.toInt() + 1)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Expense Trends',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
            CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.textSecondary,
                size: 20),
          ]),
          SizedBox(height: 2.h),
          Expanded(
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval:
                          widget.selectedRange == 'Quarter' ? 1000 : 200,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.borderColor.withValues(alpha: 0.3),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(_getXAxisLabel(value),
                                        style: AppTheme
                                            .darkTheme.textTheme.labelSmall
                                            ?.copyWith(
                                                color:
                                                    AppTheme.textSecondary)));
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: widget.selectedRange == 'Quarter'
                                  ? 1000
                                  : 200,
                              reservedSize: 42,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                    '\$${(value / 1000).toStringAsFixed(1)}k',
                                    style: AppTheme
                                        .darkTheme.textTheme.labelSmall
                                        ?.copyWith(
                                            color: AppTheme.textSecondary));
                              }))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (_getChartData().length - 1).toDouble(),
                  minY: 0,
                  maxY: widget.selectedRange == 'Quarter'
                      ? 7000
                      : widget.selectedRange == 'Month'
                          ? 2000
                          : 1000,
                  lineBarsData: [
                    LineChartBarData(
                        spots: _getChartData(),
                        isCurved: true,
                        gradient: LinearGradient(colors: [
                          AppTheme.tealAccent,
                          AppTheme.tealAccent.withValues(alpha: 0.7),
                        ]),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: touchedIndex == index ? 6 : 4,
                                  color: AppTheme.tealAccent,
                                  strokeWidth: 2,
                                  strokeColor: AppTheme.cardBackground);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                                colors: [
                                  AppTheme.tealAccent.withValues(alpha: 0.3),
                                  AppTheme.tealAccent.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event,
                          LineTouchResponse? touchResponse) {
                        setState(() {
                          if (touchResponse != null &&
                              touchResponse.lineBarSpots != null) {
                            touchedIndex =
                                touchResponse.lineBarSpots!.first.spotIndex;
                          } else {
                            touchedIndex = null;
                          }
                        });
                      },
                      touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              return LineTooltipItem(
                                  '\$${barSpot.y.toStringAsFixed(0)}',
                                  AppTheme.darkTheme.textTheme.labelMedium!
                                      .copyWith(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w600));
                            }).toList();
                          }))))),
        ]));
  }
}
