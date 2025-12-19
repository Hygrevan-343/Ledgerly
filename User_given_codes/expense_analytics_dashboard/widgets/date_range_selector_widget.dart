import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DateRangeSelectorWidget extends StatefulWidget {
  final Function(String) onRangeSelected;
  final String selectedRange;

  const DateRangeSelectorWidget({
    Key? key,
    required this.onRangeSelected,
    required this.selectedRange,
  }) : super(key: key);

  @override
  State<DateRangeSelectorWidget> createState() =>
      _DateRangeSelectorWidgetState();
}

class _DateRangeSelectorWidgetState extends State<DateRangeSelectorWidget> {
  final List<String> _ranges = ['Week', 'Month', 'Quarter', 'Custom'];

  Future<void> _selectCustomRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.cardBackground,
              headerBackgroundColor: AppTheme.tealAccent,
              headerForegroundColor: AppTheme.primaryBlack,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryBlack;
                }
                return AppTheme.textPrimary;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.tealAccent;
                }
                return Colors.transparent;
              }),
              rangeSelectionBackgroundColor:
                  AppTheme.tealAccent.withValues(alpha: 0.3),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onRangeSelected('Custom');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date Range',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _ranges.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final range = _ranges[index];
                final isSelected = widget.selectedRange == range;

                return GestureDetector(
                  onTap: () {
                    if (range == 'Custom') {
                      _selectCustomRange();
                    } else {
                      widget.onRangeSelected(range);
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.tealAccent
                          : AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.tealAccent
                            : AppTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        range,
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryBlack
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
