import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback? onTap;

  const ReceiptCard({
    super.key,
    required this.receipt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Row(
            children: [
              _buildMerchantIcon(),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      receipt.merchantName,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.spacingXS),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            AppHelpers.formatDate(receipt.date),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeS,
                              color: AppConstants.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            ),
                            child: Text(
                              receipt.category,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXS,
                                color: _getCategoryColor(),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppHelpers.formatCurrency(receipt.amount),
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeL,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryTeal,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXS),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppConstants.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppConstants.primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Center(
        child: Text(
          AppHelpers.getMerchantInitial(receipt.merchantName),
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXL,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryTeal,
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (receipt.category.toLowerCase()) {
      case 'food & dining':
        return const Color(0xFFFF9800); // Orange
      case 'retail / shopping':
        return const Color(0xFF9C27B0); // Purple
      case 'travel / transportation':
        return const Color(0xFF4CAF50); // Green
      case 'utility bills':
        return const Color(0xFF2196F3); // Blue
      case 'subscription services':
        return const Color(0xFF607D8B); // Blue Grey
      case 'medical / pharmacy':
        return const Color(0xFFF44336); // Red
      case 'education / tuition':
        return const Color(0xFF795548); // Brown
      default:
        return AppConstants.categoryOther;
    }
  }
} 