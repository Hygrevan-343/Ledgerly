import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryBreakdownWidget extends StatefulWidget {
  final Function(String) onCategoryTapped;

  const CategoryBreakdownWidget({
    Key? key,
    required this.onCategoryTapped,
  }) : super(key: key);

  @override
  State<CategoryBreakdownWidget> createState() =>
      _CategoryBreakdownWidgetState();
}

class _CategoryBreakdownWidgetState extends State<CategoryBreakdownWidget> {
  final List<Map<String, dynamic>> categoryData = [
    {
      "category": "Food & Dining",
      "amount": 1250.0,
      "percentage": 0.35,
      "color": const Color(0xFF008080),
      "icon": "restaurant",
      "transactions": 24,
    },
    {
      "category": "Transportation",
      "amount": 890.0,
      "percentage": 0.25,
      "color": const Color(0xFF00A0A0),
      "icon": "directions_car",
      "transactions": 18,
    },
    {
      "category": "Shopping",
      "amount": 680.0,
      "percentage": 0.19,
      "color": const Color(0xFF20B2B2),
      "icon": "shopping_bag",
      "transactions": 15,
    },
    {
      "category": "Entertainment",
      "amount": 420.0,
      "percentage": 0.12,
      "color": const Color(0xFF40C4C4),
      "icon": "movie",
      "transactions": 8,
    },
    {
      "category": "Utilities",
      "amount": 320.0,
      "percentage": 0.09,
      "color": const Color(0xFF60D6D6),
      "icon": "electrical_services",
      "transactions": 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalAmount = categoryData.fold<double>(
        0, (sum, item) => sum + (item["amount"] as double));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category Breakdown',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(0)}',
                style: AppTheme.getCurrencyStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.tealAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...categoryData.map((category) {
            return GestureDetector(
              onTap: () =>
                  widget.onCategoryTapped(category["category"] as String),
              child: Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: (category["color"] as Color)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: category["icon"] as String,
                              color: category["color"] as Color,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category["category"] as String,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '\$${(category["amount"] as double).toStringAsFixed(0)}',
                                    style: AppTheme.getCurrencyStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${category["transactions"]} transactions',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${((category["percentage"] as double) * 100).toStringAsFixed(0)}%',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 0.8.h,
                      decoration: BoxDecoration(
                        color: AppTheme.borderColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: category["percentage"] as double,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                category["color"] as Color,
                                (category["color"] as Color)
                                    .withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
