import 'package:flutter/material.dart';
import '../models/expense_pass.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ExpensePassPopup extends StatelessWidget {
  final ExpensePass pass;
  final String groupName;
  final VoidCallback? onViewDetails;
  final VoidCallback? onClose;

  const ExpensePassPopup({
    super.key,
    required this.pass,
    required this.groupName,
    this.onViewDetails,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(AppConstants.spacingM),
        padding: const EdgeInsets.all(AppConstants.spacingL),
        decoration: BoxDecoration(
          color: AppConstants.surfaceDark,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success animation and title
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.primaryTeal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppConstants.primaryTeal,
                size: 48,
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),
            
            Text(
              '🎉 Pass Generated!',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingS),
            
            Text(
              'Your expense pass has been created and shared with the group',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingL),
            
            // Pass details
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.backgroundDark,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: AppConstants.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt,
                        color: AppConstants.primaryTeal,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Expanded(
                        child: Text(
                          pass.merchantName,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeL,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  
                  // Total amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      Text(
                        '₹${pass.totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeL,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  
                  // Group info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Group:',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      Text(
                        groupName,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  
                  // Created by
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Created by:',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      Text(
                        pass.createdBy,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  
                  // Members count
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                      vertical: AppConstants.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: AppConstants.primaryTeal,
                          size: 16,
                        ),
                        const SizedBox(width: AppConstants.spacingXS),
                        Text(
                          '${pass.memberExpenses.length} members notified via email',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeS,
                            color: AppConstants.primaryTeal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.textSecondary,
                      side: BorderSide(color: AppConstants.dividerColor),
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onViewDetails?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required ExpensePass pass,
    required String groupName,
    VoidCallback? onViewDetails,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExpensePassPopup(
        pass: pass,
        groupName: groupName,
        onViewDetails: onViewDetails,
        onClose: onClose,
      ),
    );
  }
}

class CallProgressPopup extends StatefulWidget {
  final String merchantName;
  final String groupName;
  final VoidCallback? onCancel;

  const CallProgressPopup({
    super.key,
    required this.merchantName,
    required this.groupName,
    this.onCancel,
  });

  @override
  State<CallProgressPopup> createState() => _CallProgressPopupState();

  static void show(
    BuildContext context, {
    required String merchantName,
    required String groupName,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CallProgressPopup(
        merchantName: merchantName,
        groupName: groupName,
        onCancel: onCancel,
      ),
    );
  }
}

class _CallProgressPopupState extends State<CallProgressPopup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(AppConstants.spacingM),
        padding: const EdgeInsets.all(AppConstants.spacingL),
        decoration: BoxDecoration(
          color: AppConstants.surfaceDark,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loading animation
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryTeal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone,
                      color: AppConstants.primaryTeal,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppConstants.spacingM),
            
            Text(
              '📞 Call in Progress',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingS),
            
            Text(
              'Please tell the bot about your expense at ${widget.merchantName}',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingL),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.backgroundDark,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: AppConstants.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.phone_in_talk,
                        color: AppConstants.primaryTeal,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Expanded(
                        child: Text(
                          'Your phone should be ringing now',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    'Answer the call and tell Raseed who ordered what from ${widget.merchantName}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingS),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Text(
                      '💡 Press * on your phone when done speaking',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: AppConstants.primaryTeal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.textSecondary,
                  side: BorderSide(color: AppConstants.dividerColor),
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                ),
                child: const Text('Cancel Call'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 