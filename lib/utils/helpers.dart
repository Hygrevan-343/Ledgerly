import 'package:intl/intl.dart';

class AppHelpers {
  // Format currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    return formatter.format(amount);
  }
  
  // Format date
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
  
  // Format short date
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
  
  // Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage > 0 ? '+' : ''}${percentage.toStringAsFixed(0)}%';
  }
  
  // Get percentage change color
  static String getPercentageColor(double percentage) {
    return percentage >= 0 ? 'positive' : 'negative';
  }
  
  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  // Get time ago string
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatShortDate(date);
    }
  }
  
  // Get merchant initial
  static String getMerchantInitial(String merchantName) {
    if (merchantName.isEmpty) return 'M';
    return merchantName[0].toUpperCase();
  }
  
  // Get category emoji
  static String getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
      case 'dining':
        return '🍽️';
      case 'groceries':
        return '🛒';
      case 'transportation':
      case 'transport':
        return '🚗';
      case 'shopping':
        return '🛍️';
      case 'entertainment':
        return '🎬';
      case 'healthcare':
        return '⚕️';
      case 'utilities':
        return '⚡';
      case 'travel':
        return '✈️';
      default:
        return '📄';
    }
  }
  
  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  // Generate random ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  // Calculate progress percentage
  static double calculateProgress(double current, double target) {
    if (target == 0) return 0;
    return (current / target).clamp(0.0, 1.0);
  }
  
  // Get month name
  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  // Get short month name
  static String getShortMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
} 