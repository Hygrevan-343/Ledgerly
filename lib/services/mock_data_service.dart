import '../models/receipt.dart';
import '../models/expense_category.dart';
import '../models/chart_data.dart';

class MockDataService {
  // Sample chat responses for AI assistant - Kavinesh's specific data
  static String getMockChatResponse(String query) {
    final lowerQuery = query.toLowerCase();

    // Kavinesh's personal greeting
    if (lowerQuery.contains("hello") || lowerQuery.contains("hi") || lowerQuery.contains("kavinesh")) {
      return "Hello Kavinesh! 👋 I can see you've spent ₹28,750 this month with a 12% increase from last month. Your daily average is ₹959. How can I help you with your spending analysis today?";
    }

    // Monthly spending summary
    if (lowerQuery.contains("month") || lowerQuery.contains("summary") || lowerQuery.contains("total")) {
      return "Hi Kavinesh! This month you've spent ₹28,750 with a 12% increase from last month. Your biggest expense was University fees (₹25,000), followed by shopping (₹4,700). You spent ₹850 today and ₹4,640 this week.";
    }

    // Daily and weekly spending
    if (lowerQuery.contains("today") || lowerQuery.contains("daily")) {
      return "Today you've spent ₹850, Kavinesh. Your daily average is ₹959, which is 12% higher than last month's average. Your peak spending day was Saturday with ₹1,860.";
    }

    if (lowerQuery.contains("week") || lowerQuery.contains("weekly")) {
      return "This week you've spent ₹4,640, Kavinesh. Your peak day was Saturday with ₹1,860. Today's spending of ₹850 is below your daily average of ₹959.";
    }

    // Education spending
    if (lowerQuery.contains("education") || lowerQuery.contains("tuition") || lowerQuery.contains("university")) {
      return "Your education expenses this month total ₹25,000, Kavinesh. This includes your semester tuition fee and lab fees paid to the University. It represents 87% of your total monthly spending.";
    }

    // Shopping spending
    if (lowerQuery.contains("retail") || lowerQuery.contains("shopping") || lowerQuery.contains("amazon") || lowerQuery.contains("bazaar")) {
      return "You've spent ₹4,700 on retail/shopping this month, Kavinesh. This includes ₹2,850 at Amazon for electronics and books, and ₹1,850 at Big Bazaar for household items. That's 16.4% of your total spending.";
    }

    // Food & Dining
    if (lowerQuery.contains("food") || lowerQuery.contains("dining") || lowerQuery.contains("restaurant") || lowerQuery.contains("coffee")) {
      return "Your food & dining expenses are ₹430 this month, Kavinesh. This includes ₹250 at Cafe Coffee Day and ₹180 at McDonald's. That's about ₹14 per day on average.";
    }

    // Transportation
    if (lowerQuery.contains("travel") || lowerQuery.contains("transportation") || lowerQuery.contains("uber")) {
      return "You spent ₹320 on travel/transportation this month, Kavinesh. This was mainly an Uber ride that cost ₹320. It represents 1.1% of your total monthly spending.";
    }

    // Subscriptions
    if (lowerQuery.contains("subscription") || lowerQuery.contains("spotify")) {
      return "Your subscription services cost ₹119 this month, Kavinesh. This is just your Spotify Premium subscription. It's a recurring monthly expense and represents 0.4% of your total spending.";
    }

    // Medical expenses
    if (lowerQuery.contains("medical") || lowerQuery.contains("pharmacy") || lowerQuery.contains("apollo")) {
      return "You spent ₹450 on medical/pharmacy expenses this month, Kavinesh. This was at Apollo Pharmacy for prescription drugs and vitamins. It represents 1.6% of your total spending.";
    }

    // Utility bills
    if (lowerQuery.contains("utility") || lowerQuery.contains("bills") || lowerQuery.contains("electricity") || lowerQuery.contains("bescom")) {
      return "Your utility bills total ₹1,200 this month, Kavinesh. This is your BESCOM electricity bill, which is a recurring monthly expense. It represents 4.2% of your total spending.";
    }

    // Spending breakdown
    if (lowerQuery.contains("breakdown") || lowerQuery.contains("category") || lowerQuery.contains("categories")) {
      return "Here's your spending breakdown, Kavinesh: Education (87%), Retail/Shopping (16.4%), Utility Bills (4.2%), Medical (1.6%), Food & Dining (1.5%), Travel (1.1%), Subscriptions (0.4%). Your education expenses dominate this month.";
    }

    // Peak spending day
    if (lowerQuery.contains("peak") || lowerQuery.contains("highest") || lowerQuery.contains("most") || lowerQuery.contains("saturday")) {
      return "Your peak spending day was Saturday with ₹1,860, Kavinesh. This was higher than your daily average of ₹959. Today you've spent ₹850, which is below your average.";
    }

    // Savings advice
    if (lowerQuery.contains("save") || lowerQuery.contains("budget") || lowerQuery.contains("advice")) {
      return "Based on your pattern, Kavinesh, your major expense is education (₹25,000). For other categories, you could potentially save on shopping by comparing prices before big purchases like Amazon orders. Your daily spending of ₹959 is quite reasonable excluding the education fee.";
    }

    // Comparison with last month
    if (lowerQuery.contains("last month") || lowerQuery.contains("previous") || lowerQuery.contains("compare")) {
      return "You're spending 12% more than last month, Kavinesh. Your daily average has increased from previous month's average to ₹959. The increase is likely due to the large education payment this month.";
    }

    // Default response
    return "I'm your personal finance assistant, Kavinesh! I can help you analyze your ₹28,750 monthly spending across categories like education (₹25,000), shopping (₹4,700), utilities (₹1,200), and more. What would you like to know about your expenses?";
  }

  // Sample suggestion buttons for AI assistant - Kavinesh specific
  static List<String> getChatSuggestions() {
    return [
      "Show my monthly spending summary",
      "How much did I spend on education?",
      "What was my peak spending day?",
      "Compare with last month's spending",
      "Show my daily average spending",
    ];
  }



  // Kavinesh's specific receipt data
  static List<Receipt> getSampleReceipts() {
    final now = DateTime.now();
    return [
      Receipt.mock(
        id: 1,
        merchantName: "Cafe Coffee Day",
        amount: 250,
        date: now.subtract(const Duration(hours: 3)),
        category: "Food & Dining",
        notes: "Morning coffee break",
      ),
      Receipt.mock(
        id: 2,
        merchantName: "Big Bazaar",
        amount: 1850,
        date: now.subtract(const Duration(days: 1)),
        category: "Retail / Shopping",
        notes: "Monthly grocery shopping",
      ),
      Receipt.mock(
        id: 3,
        merchantName: "Uber",
        amount: 320,
        date: now.subtract(const Duration(days: 2)),
        category: "Travel / Transportation",
        notes: "Ride to work",
      ),
      Receipt.mock(
        id: 4,
        merchantName: "Spotify",
        amount: 119,
        date: now.subtract(const Duration(days: 15)),
        category: "Subscription Services",
        notes: "Monthly music subscription",
      ),
      Receipt.mock(
        id: 5,
        merchantName: "McDonald's",
        amount: 180,
        date: now.subtract(const Duration(days: 3)),
        category: "Food & Dining",
        notes: "Quick lunch",
      ),
      Receipt.mock(
        id: 6,
        merchantName: "Amazon",
        amount: 2850,
        date: now.subtract(const Duration(days: 4)),
        category: "Retail / Shopping",
        notes: "Electronics and books",
      ),
      Receipt.mock(
        id: 7,
        merchantName: "Apollo Pharmacy",
        amount: 450,
        date: now.subtract(const Duration(days: 6)),
        category: "Medical / Pharmacy",
        notes: "Monthly medicines",
      ),
      Receipt.mock(
        id: 8,
        merchantName: "University",
        amount: 25000,
        date: now.subtract(const Duration(days: 10)),
        category: "Education / Tuition",
        notes: "Semester tuition fee",
      ),
      Receipt.mock(
        id: 9,
        merchantName: "BESCOM",
        amount: 1200,
        date: now.subtract(const Duration(days: 20)),
        category: "Utility Bills",
        notes: "Monthly electricity bill",
      ),
    ];
  }

  // Sample recurring bills data
  static List<Receipt> getSampleRecurringBills() {
    final now = DateTime.now();
    return [
      // Recently paid bills
      Receipt.mock(
        id: 101,
        merchantName: "Netflix",
        amount: 649,
        date: now.subtract(const Duration(days: 3)),
        category: "Subscription Services",
        notes: "Monthly subscription",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 27)),
        billStatus: "paid",
      ),
      Receipt.mock(
        id: 102,
        merchantName: "BESCOM",
        amount: 1450,
        date: now.subtract(const Duration(days: 5)),
        category: "Utility Bills",
        notes: "Monthly electricity bill",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 25)),
        billStatus: "paid",
      ),
      
      // Upcoming bills
      Receipt.mock(
        id: 103,
        merchantName: "Spotify",
        amount: 119,
        date: now.subtract(const Duration(days: 25)),
        category: "Subscription Services",
        notes: "Monthly music subscription",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 5)),
        billStatus: "active",
      ),
      Receipt.mock(
        id: 104,
        merchantName: "Airtel Broadband",
        amount: 899,
        date: now.subtract(const Duration(days: 22)),
        category: "Utility Bills",
        notes: "Monthly internet bill",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 8)),
        billStatus: "active",
      ),
      Receipt.mock(
        id: 105,
        merchantName: "Cult.fit",
        amount: 1200,
        date: now.subtract(const Duration(days: 20)),
        category: "Health & Fitness",
        notes: "Monthly gym membership",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 10)),
        billStatus: "active",
      ),
      
      // Overdue bills
      Receipt.mock(
        id: 106,
        merchantName: "BWSSB",
        amount: 350,
        date: now.subtract(const Duration(days: 35)),
        category: "Utility Bills",
        notes: "Monthly water bill",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.subtract(const Duration(days: 2)),
        billStatus: "overdue",
      ),
      Receipt.mock(
        id: 107,
        merchantName: "Bajaj Allianz",
        amount: 3500,
        date: now.subtract(const Duration(days: 95)),
        category: "Insurance",
        notes: "Quarterly car insurance",
        isRecurring: true,
        frequency: "quarterly",
        nextDueDate: now.subtract(const Duration(days: 5)),
        billStatus: "overdue",
      ),
      
      // Other active bills
      Receipt.mock(
        id: 108,
        merchantName: "Adobe Creative Cloud",
        amount: 1700,
        date: now.subtract(const Duration(days: 15)),
        category: "Subscription Services",
        notes: "Monthly creative suite",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 15)),
        billStatus: "active",
      ),
      Receipt.mock(
        id: 109,
        merchantName: "Star Health",
        amount: 2800,
        date: now.subtract(const Duration(days: 28)),
        category: "Insurance",
        notes: "Monthly health insurance",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 2)),
        billStatus: "active",
      ),
      Receipt.mock(
        id: 110,
        merchantName: "Airtel",
        amount: 499,
        date: now.subtract(const Duration(days: 18)),
        category: "Utility Bills",
        notes: "Monthly phone service",
        isRecurring: true,
        frequency: "monthly",
        nextDueDate: now.add(const Duration(days: 12)),
        billStatus: "active",
      ),
    ];
  }

  // Get all recurring bills
  static List<Receipt> getRecurringBills() {
    return getSampleRecurringBills();
  }

  // Get active recurring bills count
  static int getActiveBillsCount() {
    return getSampleRecurringBills()
        .where((bill) => bill.billStatus == 'active' || bill.billStatus == 'overdue')
        .length;
  }

  // Get recently paid bills (within last week)
  static List<Receipt> getRecentlyPaidBills() {
    return getSampleRecurringBills()
        .where((bill) => bill.isRecentlyPaid)
        .toList();
  }

  // Get upcoming bills (due within next week)
  static List<Receipt> getUpcomingBills() {
    return getSampleRecurringBills()
        .where((bill) => bill.isUpcoming)
        .toList();
  }

  // Get overdue bills
  static List<Receipt> getOverdueBills() {
    return getSampleRecurringBills()
        .where((bill) => bill.isOverdue)
        .toList();
  }

  // Sample spending categories
  static List<ExpenseCategory> getSampleCategories() {
    return [
      ExpenseCategory.retailShopping(),
      ExpenseCategory.foodDining(),
      ExpenseCategory.travelTransportation(),
      ExpenseCategory.utilityBills(),
      ExpenseCategory.subscriptions(),
      ExpenseCategory.medicalPharmacy(),
      ExpenseCategory.educationTuition(),
    ];
  }

  // Sample chart data for dashboard (6 months)
  static List<ChartData> getSampleChartData() {
    return [
      ChartData.forLineChart(month: "Jan", amount: 18500, monthIndex: 0),
      ChartData.forLineChart(month: "Feb", amount: 23200, monthIndex: 1),
      ChartData.forLineChart(month: "Mar", amount: 19800, monthIndex: 2),
      ChartData.forLineChart(month: "Apr", amount: 15600, monthIndex: 3),
      ChartData.forLineChart(month: "May", amount: 26400, monthIndex: 4),
      ChartData.forLineChart(month: "Jun", amount: 28750, monthIndex: 5),
    ];
  }

  // Get current month spending - Kavinesh's data  
  static double getCurrentMonthSpending() {
    return 28750.0;
  }

  // Get current month percentage change - Kavinesh's data
  static double getCurrentMonthChange() {
    return 12.0; // +12%
  }

  // Get today's spending - Kavinesh's data
  static double getTodaySpending() {
    return 850.0;
  }

  // Get this week's spending - Kavinesh's data
  static double getThisWeekSpending() {
    return 4640.0;
  }

  // Get total spending for all categories
  static double getTotalCategorySpending() {
    return getSampleCategories()
        .map((category) => category.amount)
        .reduce((a, b) => a + b);
  }

  // Get recent receipts (limited to last 3)
  static List<Receipt> getRecentReceipts() {
    return getSampleReceipts().take(3).toList();
  }

  // Get receipts by category
  static List<Receipt> getReceiptsByCategory(String category) {
    return getSampleReceipts()
        .where((receipt) => receipt.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get receipts by merchant
  static List<Receipt> getReceiptsByMerchant(String merchantName) {
    return getSampleReceipts()
        .where((receipt) => 
            receipt.merchantName.toLowerCase().contains(merchantName.toLowerCase()))
        .toList();
  }

  // Search receipts by query
  static List<Receipt> searchReceipts(String query) {
    final lowerQuery = query.toLowerCase();
    return getSampleReceipts()
        .where((receipt) => 
            receipt.merchantName.toLowerCase().contains(lowerQuery) ||
            receipt.category.toLowerCase().contains(lowerQuery) ||
            (receipt.notes?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  // Get monthly spending trend
  static Map<String, double> getMonthlyTrend() {
    return {
      'Jan': 850.0,
      'Feb': 1100.0,
      'Mar': 950.0,
      'Apr': 750.0,
      'May': 1350.0,
      'Jun': 1234.0,
    };
  }

  // Simulate adding a new receipt
  static bool addReceipt(Receipt receipt) {
    // In a real app, this would save to database
    // For now, just return success
    return true;
  }

  // Get merchant logos/icons (placeholder URLs)
  static String getMerchantIcon(String merchantName) {
    switch (merchantName.toLowerCase()) {
      case 'starbucks':
        return 'https://logo.clearbit.com/starbucks.com';
      case 'target':
        return 'https://logo.clearbit.com/target.com';
      case 'amazon':
        return 'https://logo.clearbit.com/amazon.com';
      case 'walmart':
      case 'walmart grocery':
        return 'https://logo.clearbit.com/walmart.com';
      case 'mcdonald\'s':
        return 'https://logo.clearbit.com/mcdonalds.com';
      case 'uber':
        return 'https://logo.clearbit.com/uber.com';
      case 'shell':
      case 'shell gas station':
        return 'https://logo.clearbit.com/shell.com';
      case 'safeway':
        return 'https://logo.clearbit.com/safeway.com';
      default:
        return '';
    }
  }
} 