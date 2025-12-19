import 'package:flutter/material.dart';
import '../models/expense_category.dart';
import '../utils/constants.dart';

class CategoryProgressBar extends StatelessWidget {
  final List<ExpenseCategory> categories;
  final double height;

  const CategoryProgressBar({
    super.key,
    required this.categories,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final total = categories.fold<double>(0, (sum, cat) => sum + cat.amount);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: AppConstants.dividerColor,
          ),
          child: Row(
            children: categories.map((category) {
              final percentage = category.amount / total;
              return Expanded(
                flex: (percentage * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppConstants.spacingS,
      runSpacing: AppConstants.spacingXS,
      children: categories.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _getShortName(category.name),
              style: const TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getShortName(String name) {
    switch (name) {
      case 'Retail / Shopping':
        return 'Shopping';
      case 'Food & Dining':
        return 'Dining';
      case 'Travel / Transportation':
        return 'Travel';
      case 'Utility Bills':
        return 'Utilities';
      case 'Subscription Services':
        return 'Subscriptions';
      case 'Medical / Pharmacy':
        return 'Medical';
      case 'Education / Tuition':
        return 'Education';
      default:
        return name;
    }
  }
} 