import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AnalyticsSegmentedControlWidget extends StatelessWidget {
  final String selectedView;
  final Function(String) onViewChanged;

  const AnalyticsSegmentedControlWidget({
    Key? key,
    required this.selectedView,
    required this.onViewChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> views = ['Trends', 'Categories', 'Compare'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(0.5.w),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: views.map((view) {
          final isSelected = selectedView == view;
          return Expanded(
            child: GestureDetector(
              onTap: () => onViewChanged(view),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.tealAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    view,
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryBlack
                          : AppTheme.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
