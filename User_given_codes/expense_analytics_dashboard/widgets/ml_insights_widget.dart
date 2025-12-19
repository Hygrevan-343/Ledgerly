import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MlInsightsWidget extends StatelessWidget {
  const MlInsightsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> insights = [
      {
        "type": "anomaly",
        "title": "Unusual Spending Detected",
        "description":
            "Your restaurant spending is 40% higher than usual this week. Consider reviewing your dining habits.",
        "icon": "warning",
        "color": AppTheme.warningOrange,
        "action": "View Details",
        "priority": "high",
      },
      {
        "type": "recommendation",
        "title": "Budget Optimization",
        "description":
            "You could save \$120/month by switching to a different subscription plan for streaming services.",
        "icon": "lightbulb",
        "color": AppTheme.tealAccent,
        "action": "Optimize",
        "priority": "medium",
      },
      {
        "type": "trend",
        "title": "Positive Trend",
        "description":
            "Great job! Your grocery spending has decreased by 15% compared to last month while maintaining variety.",
        "icon": "trending_up",
        "color": AppTheme.successGreen,
        "action": "Continue",
        "priority": "low",
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Insights',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.tealAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.tealAccent,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'ML Powered',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.tealAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...insights.map((insight) {
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (insight["color"] as Color).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: (insight["color"] as Color)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: insight["icon"] as String,
                            color: insight["color"] as Color,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  insight["title"] as String,
                                  style: AppTheme.darkTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(
                                            insight["priority"] as String)
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (insight["priority"] as String)
                                        .toUpperCase(),
                                    style: AppTheme
                                        .darkTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: _getPriorityColor(
                                          insight["priority"] as String),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    insight["description"] as String,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle insight action
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: insight["color"] as Color,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            insight["action"] as String,
                            style: AppTheme.darkTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: insight["color"] as Color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: insight["color"] as Color,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorRed;
      case 'medium':
        return AppTheme.warningOrange;
      case 'low':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }
}
