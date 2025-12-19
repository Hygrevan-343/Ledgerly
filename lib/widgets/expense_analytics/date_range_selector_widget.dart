import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class DateRangeSelectorWidget extends StatefulWidget {
  final Function(String) onRangeSelected;
  final String selectedRange;

  const DateRangeSelectorWidget({
    super.key,
    required this.onRangeSelected,
    required this.selectedRange,
  });

  @override
  State<DateRangeSelectorWidget> createState() => _DateRangeSelectorWidgetState();
}

class _DateRangeSelectorWidgetState extends State<DateRangeSelectorWidget> {
  final List<String> _ranges = ['Week', 'Month', 'Quarter', 'Custom'];
  DateTimeRange? customDateRange;

  Future<void> _selectCustomRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: customDateRange ?? DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppConstants.surfaceDark,
              headerBackgroundColor: AppConstants.primaryTeal,
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return AppConstants.textPrimary;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppConstants.primaryTeal;
                }
                return Colors.transparent;
              }),
              rangeSelectionBackgroundColor: AppConstants.primaryTeal.withOpacity(0.3),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        customDateRange = picked;
      });
      widget.onRangeSelected('Custom');
    }
  }

  String _getCustomRangeDisplay() {
    if (customDateRange != null) {
      final formatter = DateFormat('MMM d');
      return '${formatter.format(customDateRange!.start)} - ${formatter.format(customDateRange!.end)}';
    }
    return 'Custom';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontSize: AppConstants.fontSizeXL,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _ranges.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppConstants.spacingM),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                      vertical: AppConstants.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppConstants.primaryTeal : AppConstants.cardDark,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      border: Border.all(
                        color: isSelected ? AppConstants.primaryTeal : AppConstants.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        range == 'Custom' ? _getCustomRangeDisplay() : range,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppConstants.textPrimary,
                          fontSize: AppConstants.fontSizeM,
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