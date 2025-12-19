import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_filter_panel_widget.dart';
import './widgets/analytics_segmented_control_widget.dart';
import './widgets/category_breakdown_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/expense_trend_chart_widget.dart';
import './widgets/ml_insights_widget.dart';
import './widgets/spending_velocity_widget.dart';

class ExpenseAnalyticsDashboard extends StatefulWidget {
  const ExpenseAnalyticsDashboard({Key? key}) : super(key: key);

  @override
  State<ExpenseAnalyticsDashboard> createState() =>
      _ExpenseAnalyticsDashboardState();
}

class _ExpenseAnalyticsDashboardState extends State<ExpenseAnalyticsDashboard>
    with TickerProviderStateMixin {
  String selectedDateRange = 'Month';
  String selectedAnalyticsView = 'Trends';
  bool isFilterPanelVisible = false;
  bool isRefreshing = false;
  Map<String, dynamic> appliedFilters = {};

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Bottom navigation
  int _currentIndex = 1; // Analytics Dashboard is at index 1

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });

    // Haptic feedback for refresh completion
    HapticFeedback.lightImpact();
  }

  void _onDateRangeSelected(String range) {
    setState(() {
      selectedDateRange = range;
    });
    HapticFeedback.selectionClick();
  }

  void _onAnalyticsViewChanged(String view) {
    setState(() {
      selectedAnalyticsView = view;
    });
    HapticFeedback.selectionClick();
  }

  void _onCategoryTapped(String category) {
    // Navigate to category details or show drill-down
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for $category'),
        backgroundColor: AppTheme.tealAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
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
        content: Text('Filters applied successfully'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    HapticFeedback.selectionClick();

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
            context, '/financial-overview-dashboard');
        break;
      case 1:
        // Current screen - do nothing
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/bill-management-dashboard');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/budget-monitoring-dashboard');
        break;
    }
  }

  Widget _buildCurrentAnalyticsView() {
    switch (selectedAnalyticsView) {
      case 'Trends':
        return Column(
          children: [
            ExpenseTrendChartWidget(selectedRange: selectedDateRange),
            const SpendingVelocityWidget(),
          ],
        );
      case 'Categories':
        return CategoryBreakdownWidget(onCategoryTapped: _onCategoryTapped);
      case 'Compare':
        return Column(
          children: [
            ExpenseTrendChartWidget(selectedRange: selectedDateRange),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Period Comparison',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Period',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '\$3,560',
                            style: AppTheme.getCurrencyStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Previous Period',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '\$3,120',
                            style: AppTheme.getCurrencyStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.warningOrange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'trending_up',
                          color: AppTheme.warningOrange,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '+14.1% increase',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.warningOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return ExpenseTrendChartWidget(selectedRange: selectedDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        title: Text(
          'Expense Analytics',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFilterPanel,
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.textPrimary,
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
                        color: AppTheme.tealAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _refreshData,
            icon: isRefreshing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.tealAccent),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.textPrimary,
                    size: 24,
                  ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            color: AppTheme.tealAccent,
            backgroundColor: AppTheme.cardBackground,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Date Range Selector
                  DateRangeSelectorWidget(
                    onRangeSelected: _onDateRangeSelected,
                    selectedRange: selectedDateRange,
                  ),

                  // Analytics Segmented Control
                  AnalyticsSegmentedControlWidget(
                    selectedView: selectedAnalyticsView,
                    onViewChanged: _onAnalyticsViewChanged,
                  ),

                  // Current Analytics View
                  _buildCurrentAnalyticsView(),

                  // ML Insights
                  const MlInsightsWidget(),

                  // Bottom padding for navigation
                  SizedBox(height: 10.h),
                ],
              ),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceElevated,
        selectedItemColor: AppTheme.tealAccent,
        unselectedItemColor: AppTheme.textSecondary,
        selectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.tealAccent
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _currentIndex == 1
                  ? AppTheme.tealAccent
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'receipt_long',
              color: _currentIndex == 2
                  ? AppTheme.tealAccent
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: _currentIndex == 3
                  ? AppTheme.tealAccent
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Budget',
          ),
        ],
      ),
    );
  }
}
