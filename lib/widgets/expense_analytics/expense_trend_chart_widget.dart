import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ExpenseTrendChartWidget extends StatefulWidget {
  final String selectedRange;
  final AppProvider provider;

  const ExpenseTrendChartWidget({
    super.key,
    required this.selectedRange,
    required this.provider,
  });

  @override
  State<ExpenseTrendChartWidget> createState() => _ExpenseTrendChartWidgetState();
}

class _ExpenseTrendChartWidgetState extends State<ExpenseTrendChartWidget> {
  int? touchedIndex;

  List<FlSpot> _getChartData() {
    final baseSpending = widget.provider.currentMonthSpending;
    
    switch (widget.selectedRange) {
      case 'Week':
        return [
          FlSpot(0, baseSpending * 0.15),
          FlSpot(1, baseSpending * 0.11),
          FlSpot(2, baseSpending * 0.23),
          FlSpot(3, baseSpending * 0.10),
          FlSpot(4, baseSpending * 0.18),
          FlSpot(5, baseSpending * 0.26),
          FlSpot(6, baseSpending * 0.14),
        ];
      case 'Month':
        return [
          FlSpot(0, baseSpending * 0.8),
          FlSpot(1, baseSpending * 0.65),
          FlSpot(2, baseSpending * 0.95),
          FlSpot(3, baseSpending * 0.75),
          FlSpot(4, baseSpending * 1.1),
          FlSpot(5, baseSpending * 0.9),
          FlSpot(6, baseSpending * 1.25),
          FlSpot(7, baseSpending * 1.0),
        ];
      case 'Quarter':
        return [
          FlSpot(0, baseSpending * 2.8),
          FlSpot(1, baseSpending * 2.5),
          FlSpot(2, baseSpending * 3.1),
          FlSpot(3, baseSpending * 2.75),
          FlSpot(4, baseSpending * 3.4),
          FlSpot(5, baseSpending * 3.2),
          FlSpot(6, baseSpending * 3.6),
          FlSpot(7, baseSpending * 3.3),
          FlSpot(8, baseSpending * 3.8),
          FlSpot(9, baseSpending * 3.5),
          FlSpot(10, baseSpending * 4.0),
          FlSpot(11, baseSpending * 3.7),
        ];
      default:
        return [
          FlSpot(0, baseSpending * 0.8),
          FlSpot(1, baseSpending * 0.65),
          FlSpot(2, baseSpending * 0.95),
          FlSpot(3, baseSpending * 0.75),
          FlSpot(4, baseSpending * 1.1),
          FlSpot(5, baseSpending * 0.9),
          FlSpot(6, baseSpending * 1.25),
          FlSpot(7, baseSpending * 1.0),
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
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return value.toInt() < months.length ? months[value.toInt()] : '';
      default:
        return 'W${(value.toInt() + 1)}';
    }
  }

  double _getMaxY() {
    final data = _getChartData();
    final maxValue = data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      margin: const EdgeInsets.all(AppConstants.spacingM),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.cardDark,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expense Trends',
                style: TextStyle(
                  color: AppConstants.textPrimary,
                  fontSize: AppConstants.fontSizeXL,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.info_outline,
                color: AppConstants.textSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxY() / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppConstants.dividerColor.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
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
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _getXAxisLabel(value),
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: AppConstants.fontSizeS,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getMaxY() / 5,
                      reservedSize: 50,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '₹${(value / 1000).toStringAsFixed(1)}k',
                          style: const TextStyle(
                            color: AppConstants.textSecondary,
                            fontSize: AppConstants.fontSizeS,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (_getChartData().length - 1).toDouble(),
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.primaryTeal,
                        AppConstants.primaryTeal.withOpacity(0.7),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: touchedIndex == index ? 6 : 4,
                          color: AppConstants.primaryTeal,
                          strokeWidth: 2,
                          strokeColor: AppConstants.cardDark,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primaryTeal.withOpacity(0.3),
                          AppConstants.primaryTeal.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    setState(() {
                      if (touchResponse != null && touchResponse.lineBarSpots != null) {
                        touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
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
                          AppHelpers.formatCurrency(barSpot.y),
                          const TextStyle(
                            color: AppConstants.textPrimary,
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 