import 'package:flutter/material.dart';
import '../models/expense_category.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingS),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppConstants.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingS),
              Flexible(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXS),
              Flexible(
                child: Text(
                  AppHelpers.formatCurrency(category.amount),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 