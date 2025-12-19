import 'package:flutter/foundation.dart';
import '../models/receipt.dart';
import '../models/expense_category.dart';
import '../models/chart_data.dart';
import '../services/mock_data_service.dart';
import '../services/widget_service.dart';

class AppProvider with ChangeNotifier {
  // Receipts
  List<Receipt> _receipts = [];
  List<Receipt> _filteredReceipts = [];
  
  // Categories
  List<ExpenseCategory> _categories = [];
  
  // Chart Data
  List<ChartData> _chartData = [];
  
  // Loading states
  bool _isLoading = false;
  
  // Current spending data
  double _currentMonthSpending = 0.0;
  double _monthlyChange = 0.0;
  double _todaySpending = 0.0;
  double _weekSpending = 0.0;
  
  // Chat messages
  List<ChatMessage> _chatMessages = [];
  bool _isTyping = false;

  // Getters
  List<Receipt> get receipts => _receipts;
  List<Receipt> get filteredReceipts => _filteredReceipts;
  List<ExpenseCategory> get categories => _categories;
  List<ChartData> get chartData => _chartData;
  bool get isLoading => _isLoading;
  double get currentMonthSpending => _currentMonthSpending;
  double get monthlyChange => _monthlyChange;
  double get todaySpending => _todaySpending;
  double get weekSpending => _weekSpending;
  List<ChatMessage> get chatMessages => _chatMessages;
  bool get isTyping => _isTyping;

  AppProvider() {
    _loadData();
  }

  // Load initial data
  void _loadData() {
    _setLoading(true);
    
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _receipts = MockDataService.getSampleReceipts();
      _filteredReceipts = List.from(_receipts);
      _categories = MockDataService.getSampleCategories();
      _chartData = MockDataService.getSampleChartData();
      
      _currentMonthSpending = MockDataService.getCurrentMonthSpending();
      _monthlyChange = MockDataService.getCurrentMonthChange();
      _todaySpending = MockDataService.getTodaySpending();
      _weekSpending = MockDataService.getThisWeekSpending();
      
      _setLoading(false);
      
      // Update widget with latest data
      WidgetService.updateWidget();
    });
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Filter receipts
  void filterReceipts(String query) {
    if (query.isEmpty) {
      _filteredReceipts = List.from(_receipts);
    } else {
      _filteredReceipts = MockDataService.searchReceipts(query);
    }
    notifyListeners();
  }

  // Add new receipt
  Future<bool> addReceipt(Receipt receipt) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final success = MockDataService.addReceipt(receipt);
    if (success) {
      _receipts.insert(0, receipt);
      _filteredReceipts = List.from(_receipts);
    }
    
    _setLoading(false);
    
    // Update widget after new receipt is added
    if (success) {
      WidgetService.updateWidget();
    }
    
    return success;
  }

  // Send chat message
  Future<void> sendChatMessage(String message) async {
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    _chatMessages.add(userMessage);
    notifyListeners();
    
    // Show typing indicator
    _isTyping = true;
    notifyListeners();
    
    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final response = MockDataService.getMockChatResponse(message);
    final aiMessage = ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    _isTyping = false;
    _chatMessages.add(aiMessage);
    notifyListeners();
  }

  // Clear chat
  void clearChat() {
    _chatMessages.clear();
    notifyListeners();
  }

  // Get receipts by category
  List<Receipt> getReceiptsByCategory(String category) {
    return MockDataService.getReceiptsByCategory(category);
  }

  // Refresh data
  Future<void> refreshData() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 1000));
    _loadData();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
} 