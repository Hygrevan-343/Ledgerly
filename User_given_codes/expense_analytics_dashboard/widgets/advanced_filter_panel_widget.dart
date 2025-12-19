import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedFilterPanelWidget extends StatefulWidget {
  final bool isVisible;
  final Function() onClose;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const AdvancedFilterPanelWidget({
    Key? key,
    required this.isVisible,
    required this.onClose,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<AdvancedFilterPanelWidget> createState() =>
      _AdvancedFilterPanelWidgetState();
}

class _AdvancedFilterPanelWidgetState extends State<AdvancedFilterPanelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String selectedMerchant = 'All';
  RangeValues amountRange = const RangeValues(0, 5000);
  String selectedPaymentMethod = 'All';

  final List<String> merchants = [
    'All',
    'Amazon',
    'Starbucks',
    'Uber',
    'Netflix',
    'Walmart'
  ];
  final List<String> paymentMethods = [
    'All',
    'Credit Card',
    'Debit Card',
    'Cash',
    'Digital Wallet'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AdvancedFilterPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = {
      'merchant': selectedMerchant,
      'amountRange': amountRange,
      'paymentMethod': selectedPaymentMethod,
    };
    widget.onFiltersApplied(filters);
    widget.onClose();
  }

  void _resetFilters() {
    setState(() {
      selectedMerchant = 'All';
      amountRange = const RangeValues(0, 5000);
      selectedPaymentMethod = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: AppTheme.overlayDark,
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping on panel
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value * 100.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          width: 12.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.borderColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Header
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Advanced Filters',
                                style: AppTheme.darkTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.onClose,
                                child: CustomIconWidget(
                                  iconName: 'close',
                                  color: AppTheme.textSecondary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Merchant Filter
                                _buildFilterSection(
                                  'Merchant',
                                  DropdownButtonFormField<String>(
                                    value: selectedMerchant,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 2.h),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppTheme.borderColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppTheme.borderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppTheme.tealAccent,
                                            width: 2),
                                      ),
                                      fillColor: AppTheme.cardBackground,
                                      filled: true,
                                    ),
                                    dropdownColor: AppTheme.surfaceElevated,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.textPrimary,
                                    ),
                                    items: merchants.map((merchant) {
                                      return DropdownMenuItem(
                                        value: merchant,
                                        child: Text(merchant),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMerchant = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                // Amount Range Filter
                                _buildFilterSection(
                                  'Amount Range',
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${amountRange.start.toInt()}',
                                            style: AppTheme.getCurrencyStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '\$${amountRange.end.toInt()}',
                                            style: AppTheme.getCurrencyStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: AppTheme.tealAccent,
                                          inactiveTrackColor:
                                              AppTheme.borderColor,
                                          thumbColor: AppTheme.tealAccent,
                                          overlayColor: AppTheme.tealAccent
                                              .withValues(alpha: 0.2),
                                          valueIndicatorColor:
                                              AppTheme.tealAccent,
                                        ),
                                        child: RangeSlider(
                                          values: amountRange,
                                          min: 0,
                                          max: 5000,
                                          divisions: 50,
                                          labels: RangeLabels(
                                            '\$${amountRange.start.toInt()}',
                                            '\$${amountRange.end.toInt()}',
                                          ),
                                          onChanged: (values) {
                                            setState(() {
                                              amountRange = values;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                // Payment Method Filter
                                _buildFilterSection(
                                  'Payment Method',
                                  DropdownButtonFormField<String>(
                                    value: selectedPaymentMethod,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 2.h),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppTheme.borderColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppTheme.borderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppTheme.tealAccent,
                                            width: 2),
                                      ),
                                      fillColor: AppTheme.cardBackground,
                                      filled: true,
                                    ),
                                    dropdownColor: AppTheme.surfaceElevated,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.textPrimary,
                                    ),
                                    items: paymentMethods.map((method) {
                                      return DropdownMenuItem(
                                        value: method,
                                        child: Text(method),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 4.h),
                              ],
                            ),
                          ),
                        ),
                        // Action buttons
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBackground,
                            border: Border(
                              top: BorderSide(color: AppTheme.borderColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _resetFilters,
                                  child: Text('Reset'),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _applyFilters,
                                  child: Text('Apply Filters'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        content,
      ],
    );
  }
}
