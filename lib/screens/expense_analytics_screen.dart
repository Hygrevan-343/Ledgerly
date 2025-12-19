import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/expense_analytics/date_range_selector_widget.dart';
import '../widgets/expense_analytics/expense_trend_chart_widget.dart';
import '../widgets/expense_analytics/advanced_filter_panel_widget.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {
  String selectedDateRange = 'Month';
  bool isFilterPanelVisible = false;
  Map<String, dynamic> appliedFilters = {};

  final ScrollController _scrollController = ScrollController();

  void _onDateRangeSelected(String range) {
    setState(() {
      selectedDateRange = range;
    });
    HapticFeedback.selectionClick();
  }

  void _toggleFilterPanel() {
    setState(() {
      isFilterPanelVisible = !isFilterPanelVisible;
    });
    HapticFeedback.mediumImpact();
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      appliedFilters = filters;
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Filters applied successfully'),
        backgroundColor: AppConstants.primaryTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundDark,
        elevation: 0,
        title: const Text(
          'Expense Analytics',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontSize: AppConstants.fontSizeXL,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFilterPanel,
            icon: Stack(
              children: [
                const Icon(
                  Icons.tune,
                  color: AppConstants.textPrimary,
                  size: 24,
                ),
                if (appliedFilters.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppConstants.primaryTeal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Date Range Selector
                    DateRangeSelectorWidget(
                      onRangeSelected: _onDateRangeSelected,
                      selectedRange: selectedDateRange,
                    ),

                    // Expense Trends Chart
                    ExpenseTrendChartWidget(
                      selectedRange: selectedDateRange,
                      provider: provider,
                    ),

                    // Spending Velocity Metrics
                    _buildSpendingVelocityCard(provider),

                    // Bottom padding
                    const SizedBox(height: AppConstants.spacingXL * 2),
                  ],
                ),
              ),

              // Advanced Filter Panel
              AdvancedFilterPanelWidget(
                isVisible: isFilterPanelVisible,
                onClose: () {
                  setState(() {
                    isFilterPanelVisible = false;
                  });
                },
                onFiltersApplied: _onFiltersApplied,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSpendingVelocityCard(AppProvider provider) {
    final List<Map<String, dynamic>> velocityMetrics = [
      {
        "title": "Daily Average",
        "value": AppHelpers.formatCurrency(provider.currentMonthSpending / 30),
        "change": "+12.5%",
        "isPositive": false,
        "icon": Icons.trending_up,
        "subtitle": "vs last month",
      },
      {
        "title": "Peak Day",
        "value": "Saturday",
        "change": AppHelpers.formatCurrency(provider.weekSpending * 0.4),
        "isPositive": true,
        "icon": Icons.calendar_today,
        "subtitle": "highest spending",
      },
      {
        "title": "Budget Burn",
        "value": "68%",
        "change": "On track",
        "isPositive": true,
        "icon": Icons.local_fire_department,
        "subtitle": "of monthly budget",
      },
    ];

    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingS),
            child: Text(
              'Spending Velocity',
              style: TextStyle(
                color: AppConstants.textPrimary,
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingS),
              itemCount: velocityMetrics.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppConstants.spacingM),
              itemBuilder: (context, index) {
                final metric = velocityMetrics[index];
                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppConstants.cardDark,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: AppConstants.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            metric["icon"] as IconData,
                            color: AppConstants.primaryTeal,
                            size: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingS, 
                                vertical: AppConstants.spacingXS),
                            decoration: BoxDecoration(
                              color: (metric["isPositive"] as bool)
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            ),
                            child: Text(
                              metric["change"] as String,
                              style: TextStyle(
                                color: (metric["isPositive"] as bool)
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: AppConstants.fontSizeS,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            metric["value"] as String,
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeL,
                              fontWeight: FontWeight.w700,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXS),
                          Text(
                            metric["title"] as String,
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: AppConstants.fontSizeS,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            metric["subtitle"] as String,
                            style: TextStyle(
                              color: AppConstants.textSecondary.withOpacity(0.7),
                              fontSize: AppConstants.fontSizeS,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 