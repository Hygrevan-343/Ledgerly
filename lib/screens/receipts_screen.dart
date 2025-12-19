import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/receipt_card.dart';
import '../widgets/receipt_detail_popup.dart';
import '../models/receipt.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  bool _showAllReceipts = false;
  
  // Hardcoded data for Kavinesh
  List<Receipt> _allReceipts = [];
  List<Receipt> _filteredReceipts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load Kavinesh's hardcoded data
    _allReceipts = _getKavineshReceipts();
    _filteredReceipts = _allReceipts;
    _isLoading = false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter receipts based on search query
  void _filterReceipts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredReceipts = _allReceipts;
      } else {
        _filteredReceipts = _allReceipts.where((receipt) {
          return receipt.merchantName.toLowerCase().contains(query.toLowerCase()) ||
                 receipt.category.toLowerCase().contains(query.toLowerCase()) ||
                 (receipt.notes?.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  // Get recent receipts for display
  List<Receipt> get _displayReceipts {
    final receipts = _showSearch 
        ? _filteredReceipts 
        : _showAllReceipts 
            ? _allReceipts
            : _allReceipts.take(5).toList();
    return receipts;
  }

  // Calculate total spending for different periods - Kavinesh's actual numbers
  double get _weekSpending {
    return 4640.0; // Kavinesh's week spending
  }

  double get _monthSpending {
    return 28750.0; // Kavinesh's month spending
  }

  double get _todaySpending {
    return 850.0; // Kavinesh's today spending
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search receipts...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppConstants.textSecondary),
                ),
                style: const TextStyle(color: AppConstants.textPrimary),
                onChanged: (value) {
                  _filterReceipts(value);
                },
              )
            : const Text('Receipts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _filterReceipts('');
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryTeal,
              ),
            )
          : RefreshIndicator(
                  onRefresh: () => Future.value(), // No refresh from Firebase
                  color: AppConstants.primaryTeal,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTotalSpentCard(),
                        const SizedBox(height: AppConstants.spacingL),
                        _buildRecentReceipts(),
                        const SizedBox(height: AppConstants.spacingL),
                        _buildSpendingCategories(),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReceiptDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalSpentCard() {
    return Column(
      children: [
        // Kavinesh's stats
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppConstants.primaryTeal, AppConstants.primaryTeal.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Kavinesh! 👋',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXL,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                'Daily average: ₹959 (12% higher than last month)',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeM,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildSpendingCard(
                  title: 'Today',
                  amount: _todaySpending,
                  subtitle: null,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: _buildSpendingCard(
                  title: 'This Week', 
                  amount: _weekSpending,
                  subtitle: null,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: _buildSpendingCard(
                  title: 'This Month',
                  amount: _monthSpending,
                  subtitle: '+12% vs last month',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingCard({
    required String title,
    required double amount,
    String? subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: AppConstants.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingXS),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '₹${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryTeal,
                ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppConstants.spacingXS),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXS,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReceipts() {
    final receipts = _displayReceipts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Receipts',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            if (!_showSearch && !_showAllReceipts)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllReceipts = true;
                  });
                },
                child: const Text(
                  'View all receipts',
                  style: TextStyle(
                    color: AppConstants.primaryTeal,
                    fontSize: AppConstants.fontSizeM,
                  ),
                ),
              ),
            if (_showAllReceipts && !_showSearch)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllReceipts = false;
                  });
                },
                child: const Text(
                  'Show recent',
                  style: TextStyle(
                    color: AppConstants.primaryTeal,
                    fontSize: AppConstants.fontSizeM,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingM),
        if (receipts.isEmpty)
          _buildEmptyState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return ReceiptCard(
                receipt: receipt,
                onTap: () => ReceiptDetailPopup.show(context, receipt),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSpendingCategories() {
    if (_showSearch || _showAllReceipts) return const SizedBox.shrink();

    // Calculate category totals from Kavinesh's data
    final categoryTotals = <String, double>{
      'Education / Tuition': 25000.0,
      'Retail / Shopping': 4700.0, // Big Bazaar + Amazon
      'Utility Bills': 1200.0,
      'Medical / Pharmacy': 450.0,
      'Food & Dining': 430.0, // Cafe Coffee Day + McDonald's
      'Travel / Transportation': 320.0,
      'Subscription Services': 119.0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending Categories',
          style: TextStyle(
            fontSize: AppConstants.fontSizeXL,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        ...categoryTotals.entries.map((entry) => _buildCategoryCard(entry.key, entry.value)).toList(),
      ],
    );
  }

  Widget _buildCategoryCard(String category, double amount) {
    final percentage = (amount / _monthSpending * 100);
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: _getCategoryColor(category),
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
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
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
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
        return AppConstants.primaryTeal;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXL),
        child: Column(
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 64,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.spacingM),
            const Text(
              'No receipts found',
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            const Text(
              'Add your first receipt to get started',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReceiptDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusL),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            const Text(
              'Add Receipt',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Row(
              children: [
                Expanded(
                  child: _buildAddOption(
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    subtitle: 'Take a photo',
                    onTap: () => _takePicture(context),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: _buildAddOption(
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    subtitle: 'Choose from gallery',
                    onTap: () => _pickFromGallery(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingM),
            _buildAddOption(
              icon: Icons.edit,
              title: 'Manual Entry',
              subtitle: 'Enter receipt details manually',
              onTap: () => _manualEntry(context),
              fullWidth: true,
            ),
            const SizedBox(height: AppConstants.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: AppConstants.cardDark,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: AppConstants.dividerColor,
            width: 1,
          ),
        ),
        child: fullWidth
            ? Row(
                children: [
                  Icon(icon, color: AppConstants.primaryTeal, size: 24),
                  const SizedBox(width: AppConstants.spacingM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeL,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeS,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(icon, color: AppConstants.primaryTeal, size: 32),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeL,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: AppConstants.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  void _takePicture(BuildContext context) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _showSuccessMessage('Photo captured! Processing receipt...');
      // TODO: Process image with OCR
    }
  }

  void _pickFromGallery(BuildContext context) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _showSuccessMessage('Image selected! Processing receipt...');
      // TODO: Process image with OCR
    }
  }

  void _manualEntry(BuildContext context) {
    Navigator.pop(context);
    _showSuccessMessage('Manual entry feature coming soon!');
    // TODO: Show manual entry form
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.primaryTeal,
      ),
    );
  }

  void _showReceiptDetails(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceDark,
        title: Text(
          receipt.merchantName,
          style: const TextStyle(color: AppConstants.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount', AppHelpers.formatCurrency(receipt.amount)),
            _buildDetailRow('Date', AppHelpers.formatDate(receipt.date)),
            _buildDetailRow('Category', receipt.category),
            if (receipt.notes?.isNotEmpty == true)
              _buildDetailRow('Notes', receipt.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppConstants.primaryTeal),
            ),
          ),
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
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppConstants.textSecondary,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppConstants.textPrimary,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryDetails(BuildContext context, String categoryName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$categoryName details coming soon!'),
        backgroundColor: AppConstants.primaryTeal,
      ),
    );
  }

  // Kavinesh's actual transaction data
  List<Receipt> _getKavineshReceipts() {
    final now = DateTime.now();
    return [
      Receipt(
        id: 1,
        merchantName: 'Cafe Coffee Day',
        amount: 250.0,
        date: now.subtract(const Duration(hours: 3)),
        category: 'Food & Dining',
        notes: 'Morning coffee break',
        items: ['Cappuccino', 'Sandwich'],
        paymentMethod: 'UPI',
        location: 'Bangalore',
        tax: 37.5,
        discount: 0.0,
        subtotal: 212.5,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 2,
        merchantName: 'Big Bazaar',
        amount: 1850.0,
        date: now.subtract(const Duration(days: 1)),
        category: 'Retail / Shopping',
        notes: 'Monthly grocery shopping',
        items: ['Groceries', 'Household items', 'Personal care'],
        paymentMethod: 'Credit Card',
        location: 'Bangalore',
        tax: 111.0,
        discount: 50.0,
        subtotal: 1789.0,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 3,
        merchantName: 'Uber',
        amount: 320.0,
        date: now.subtract(const Duration(days: 2)),
        category: 'Travel / Transportation',
        notes: 'Ride to work',
        items: ['Uber ride'],
        paymentMethod: 'UPI',
        location: 'Bangalore',
        tax: 20.0,
        discount: 0.0,
        subtotal: 300.0,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 4,
        merchantName: 'Spotify',
        amount: 119.0,
        date: now.subtract(const Duration(days: 15)),
        category: 'Subscription Services',
        notes: 'Monthly music subscription',
        items: ['Spotify Premium'],
        paymentMethod: 'Credit Card',
        location: 'Online',
        tax: 21.42,
        discount: 0.0,
        subtotal: 97.58,
        isRecurring: true,
        frequency: 'monthly',
        nextDueDate: now.add(const Duration(days: 15)),
        billStatus: 'paid',
      ),
      Receipt(
        id: 5,
        merchantName: 'McDonald\'s',
        amount: 180.0,
        date: now.subtract(const Duration(days: 3)),
        category: 'Food & Dining',
        notes: 'Quick lunch',
        items: ['Big Mac meal', 'Fries', 'Coke'],
        paymentMethod: 'UPI',
        location: 'Bangalore',
        tax: 18.0,
        discount: 0.0,
        subtotal: 162.0,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 6,
        merchantName: 'Amazon',
        amount: 2850.0,
        date: now.subtract(const Duration(days: 4)),
        category: 'Retail / Shopping',
        notes: 'Electronics and books',
        items: ['Laptop accessories', 'Books', 'Phone case'],
        paymentMethod: 'Credit Card',
        location: 'Online',
        tax: 171.0,
        discount: 150.0,
        subtotal: 2829.0,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 7,
        merchantName: 'Apollo Pharmacy',
        amount: 450.0,
        date: now.subtract(const Duration(days: 6)),
        category: 'Medical / Pharmacy',
        notes: 'Monthly medicines',
        items: ['Prescription drugs', 'Vitamins'],
        paymentMethod: 'Cash',
        location: 'Bangalore',
        tax: 27.0,
        discount: 0.0,
        subtotal: 423.0,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 8,
        merchantName: 'University',
        amount: 25000.0,
        date: now.subtract(const Duration(days: 10)),
        category: 'Education / Tuition',
        notes: 'Semester tuition fee',
        items: ['Tuition fee', 'Lab fee'],
        paymentMethod: 'Bank Transfer',
        location: 'Bangalore',
        tax: 0.0,
        discount: 0.0,
        subtotal: 25000.0,
        isRecurring: false,
        frequency: '',
        billStatus: 'paid',
      ),
      Receipt(
        id: 9,
        merchantName: 'BESCOM',
        amount: 1200.0,
        date: now.subtract(const Duration(days: 20)),
        category: 'Utility Bills',
        notes: 'Monthly electricity bill',
        items: ['Electricity usage'],
        paymentMethod: 'Online Banking',
        location: 'Bangalore',
        tax: 144.0,
        discount: 0.0,
        subtotal: 1056.0,
        isRecurring: true,
        frequency: 'monthly',
        nextDueDate: now.add(const Duration(days: 10)),
        billStatus: 'paid',
      ),
    ];
  }
} 