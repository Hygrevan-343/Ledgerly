import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AdvancedFilterPanelWidget extends StatefulWidget {
  final bool isVisible;
  final Function() onClose;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const AdvancedFilterPanelWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.onFiltersApplied,
  });

  @override
  State<AdvancedFilterPanelWidget> createState() => _AdvancedFilterPanelWidgetState();
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
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping on panel
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value * MediaQuery.of(context).size.height),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppConstants.surfaceDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.radiusL),
                        topRight: Radius.circular(AppConstants.radiusL),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: const EdgeInsets.only(top: AppConstants.spacingM),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppConstants.dividerColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(AppConstants.spacingM),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Advanced Filters',
                                style: TextStyle(
                                  color: AppConstants.textPrimary,
                                  fontSize: AppConstants.fontSizeXL,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.onClose,
                                child: const Icon(
                                  Icons.close,
                                  color: AppConstants.textSecondary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Merchant Filter
                                _buildFilterSection(
                                  'Merchant',
                                  DropdownButtonFormField<String>(
                                    value: selectedMerchant,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.spacingM,
                                        vertical: AppConstants.spacingM,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                        borderSide: const BorderSide(color: AppConstants.dividerColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                        borderSide: const BorderSide(color: AppConstants.dividerColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                        borderSide: const BorderSide(
                                          color: AppConstants.primaryTeal,
                                          width: 2,
                                        ),
                                      ),
                                      fillColor: AppConstants.cardDark,
                                      filled: true,
                                    ),
                                    dropdownColor: AppConstants.surfaceDark,
                                    style: const TextStyle(color: AppConstants.textPrimary),
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
                                const SizedBox(height: AppConstants.spacingL),
                                // Amount Range Filter
                                _buildFilterSection(
                                  'Amount Range',
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₹${amountRange.start.toInt()}',
                                            style: const TextStyle(
                                              fontSize: AppConstants.fontSizeM,
                                              fontWeight: FontWeight.w500,
                                              color: AppConstants.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '₹${amountRange.end.toInt()}',
                                            style: const TextStyle(
                                              fontSize: AppConstants.fontSizeM,
                                              fontWeight: FontWeight.w500,
                                              color: AppConstants.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: AppConstants.primaryTeal,
                                          inactiveTrackColor: AppConstants.dividerColor,
                                          thumbColor: AppConstants.primaryTeal,
                                          overlayColor: AppConstants.primaryTeal.withOpacity(0.2),
                                          valueIndicatorColor: AppConstants.primaryTeal,
                                        ),
                                        child: RangeSlider(
                                          values: amountRange,
                                          min: 0,
                                          max: 5000,
                                          divisions: 50,
                                          labels: RangeLabels(
                                            '₹${amountRange.start.toInt()}',
                                            '₹${amountRange.end.toInt()}',
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
                                const SizedBox(height: AppConstants.spacingL),
                                // Payment Method Filter
                                _buildFilterSection(
                                  'Payment Method',
                                  Column(
                                    children: paymentMethods.map((method) {
                                      return RadioListTile<String>(
                                        title: Text(
                                          method,
                                          style: const TextStyle(
                                            color: AppConstants.textPrimary,
                                            fontSize: AppConstants.fontSizeM,
                                          ),
                                        ),
                                        value: method,
                                        groupValue: selectedPaymentMethod,
                                        activeColor: AppConstants.primaryTeal,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPaymentMethod = value!;
                                          });
                                        },
                                        contentPadding: EdgeInsets.zero,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: AppConstants.spacingXL),
                              ],
                            ),
                          ),
                        ),
                        // Action buttons
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingM),
                          decoration: const BoxDecoration(
                            color: AppConstants.cardDark,
                            border: Border(
                              top: BorderSide(color: AppConstants.dividerColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _resetFilters,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppConstants.dividerColor),
                                    padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(color: AppConstants.textPrimary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingM),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _applyFilters,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.primaryTeal,
                                    padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                                  ),
                                  child: const Text(
                                    'Apply Filters',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        content,
      ],
    );
  }
} 