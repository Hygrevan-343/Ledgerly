import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ReceiptDetailPopup extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailPopup({
    super.key,
    required this.receipt,
  });

  static void show(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (context) => ReceiptDetailPopup(receipt: receipt),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.primaryTeal,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusL),
                  topRight: Radius.circular(AppConstants.radiusL),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receipt Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Merchant name and amount
                    _buildMerchantHeader(),
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Receipt image if available
                    if (receipt.imageUrl != null) ...[
                      _buildReceiptImage(),
                      const SizedBox(height: AppConstants.spacingL),
                    ],
                    
                    // Transaction details
                    _buildTransactionDetails(),
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Items list
                    if (receipt.items.isNotEmpty) ...[
                      _buildItemsList(),
                      const SizedBox(height: AppConstants.spacingL),
                    ],
                    
                    // Amount breakdown
                    _buildAmountBreakdown(),
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Additional details
                    _buildAdditionalDetails(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.backgroundLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.primaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Merchant icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConstants.primaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(
              _getCategoryIcon(receipt.category),
              color: AppConstants.primaryTeal,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          
          // Merchant details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.merchantName,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXS),
                Text(
                  receipt.category,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: AppConstants.textSecondary,
                  ),
                ),
                if (receipt.location.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingXS),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppConstants.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        receipt.location,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXS,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppHelpers.formatCurrency(receipt.amount),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXL,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryTeal,
                ),
              ),
              Text(
                AppHelpers.formatDate(receipt.date),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.primaryTeal.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Image.network(
          receipt.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppConstants.backgroundLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: AppConstants.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    'Image not available',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: AppConstants.fontSizeS,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.primaryTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          _buildDetailRow('Date & Time', AppHelpers.formatDate(receipt.date)),
          _buildDetailRow('Payment Method', receipt.paymentMethod),
          if (receipt.notes?.isNotEmpty == true)
            _buildDetailRow('Notes', receipt.notes!),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.primaryTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${receipt.items.length})',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          ...receipt.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryTeal,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAmountBreakdown() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.backgroundLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.primaryTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Breakdown',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          if (receipt.subtotal > 0) 
            _buildAmountRow('Subtotal', receipt.subtotal),
          if (receipt.tax > 0)
            _buildAmountRow('Tax', receipt.tax),
          if (receipt.discount > 0)
            _buildAmountRow('Discount', -receipt.discount, isDiscount: true),
          
          const Divider(color: AppConstants.textSecondary),
          
          _buildAmountRow(
            'Total', 
            receipt.amount, 
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    if (!receipt.isRecurring) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.primaryTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recurring Payment',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          _buildDetailRow('Frequency', receipt.frequency?.toUpperCase() ?? 'N/A'),
          if (receipt.nextDueDate != null)
            _buildDetailRow('Next Due Date', AppHelpers.formatDate(receipt.nextDueDate!)),
          _buildDetailRow('Status', receipt.billStatus?.toUpperCase() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: AppConstants.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? AppConstants.fontSizeM : AppConstants.fontSizeS,
              color: AppConstants.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            AppHelpers.formatCurrency(amount),
            style: TextStyle(
              fontSize: isTotal ? AppConstants.fontSizeM : AppConstants.fontSizeS,
              color: isDiscount 
                  ? Colors.green 
                  : isTotal 
                      ? AppConstants.primaryTeal 
                      : AppConstants.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return Icons.restaurant;
      case 'retail / shopping':
        return Icons.shopping_bag;
      case 'travel / transportation':
        return Icons.directions_car;
      case 'utility bills':
        return Icons.electrical_services;
      case 'subscription services':
        return Icons.subscriptions;
      case 'medical / pharmacy':
        return Icons.local_pharmacy;
      case 'education / tuition':
        return Icons.school;
      case 'health & fitness':
        return Icons.fitness_center;
      case 'insurance':
        return Icons.security;
      default:
        return Icons.receipt;
    }
  }
} 