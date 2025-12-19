import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpendingVelocityWidget extends StatelessWidget {
  const SpendingVelocityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> velocityMetrics = [
      {
        "title": "Daily Average",
        "value": "\$127.50",
        "change": "+12.5%",
        "isPositive": false,
        "icon": "trending_up",
        "subtitle": "vs last month",
      },
      {
        "title": "Peak Day",
        "value": "Saturday",
        "change": "\$340",
        "isPositive": true,
        "icon": "calendar_today",
        "subtitle": "highest spending",
      },
      {
        "title": "Budget Burn",
        "value": "68%",
        "change": "On track",
        "isPositive": true,
        "icon": "local_fire_department",
        "subtitle": "of monthly budget",
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Spending Velocity',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 15.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: velocityMetrics.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final metric = velocityMetrics[index];
                return Container(
                  width: 40.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconWidget(
                            iconName: metric["icon"] as String,
                            color: AppTheme.tealAccent,
                            size: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: (metric["isPositive"] as bool)
                                  ? AppTheme.successGreen.withValues(alpha: 0.2)
                                  : AppTheme.warningOrange
                                      .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              metric["change"] as String,
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: (metric["isPositive"] as bool)
                                    ? AppTheme.successGreen
                                    : AppTheme.warningOrange,
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
                            style: AppTheme.getCurrencyStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            metric["title"] as String,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            metric["subtitle"] as String,
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color:
                                  AppTheme.textSecondary.withValues(alpha: 0.7),
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
