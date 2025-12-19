import 'package:home_widget/home_widget.dart';

import '../services/mock_data_service.dart';
import '../utils/helpers.dart';

class WidgetService {
  static const String _widgetName = 'RaseedWidget';
  static const String _groupId = 'group.raseed.widget';
  
  // Widget data keys
  static const String _recentBillKey = 'recent_bill';
  static const String _recentBillAmountKey = 'recent_bill_amount';
  static const String _recentBillMerchantKey = 'recent_bill_merchant';
  static const String _recentBillDateKey = 'recent_bill_date';
  static const String _totalActiveKey = 'total_active_bills';
  
  // Initialize widget
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(_groupId);
      await updateWidget();
    } catch (e) {
      print('Error initializing widget: $e');
    }
  }
  
  // Update widget with latest data
  static Future<void> updateWidget() async {
    try {
      // Get recent bills data
      final recentBills = MockDataService.getRecentlyPaidBills();
      final activeBillsCount = MockDataService.getActiveBillsCount();
      
      String recentBillText = 'No recent bills';
      String recentBillAmount = '₹0.00';
      String recentBillMerchant = '';
      String recentBillDate = '';
      
      if (recentBills.isNotEmpty) {
        final recentBill = recentBills.first;
        recentBillText = 'Recent Bill';
        recentBillAmount = AppHelpers.formatCurrency(recentBill.amount);
        recentBillMerchant = recentBill.merchantName;
        recentBillDate = AppHelpers.formatDate(recentBill.date);
      }
      
      // Save data to widget
      await HomeWidget.saveWidgetData<String>(_recentBillKey, recentBillText);
      await HomeWidget.saveWidgetData<String>(_recentBillAmountKey, recentBillAmount);
      await HomeWidget.saveWidgetData<String>(_recentBillMerchantKey, recentBillMerchant);
      await HomeWidget.saveWidgetData<String>(_recentBillDateKey, recentBillDate);
      await HomeWidget.saveWidgetData<int>(_totalActiveKey, activeBillsCount);
      
      // Update widget
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: 'RaseedWidgetProvider',
        iOSName: 'RaseedWidget',
      );
      
      print('Widget updated successfully');
    } catch (e) {
      print('Error updating widget: $e');
    }
  }
  
  // Handle widget interactions
  static Future<void> handleWidgetInteraction(String action) async {
    try {
      switch (action) {
        case 'camera':
          await _handleCameraAction();
          break;
        case 'gallery':
          await _handleGalleryAction();
          break;
        case 'assist':
          await _handleAssistAction();
          break;
        default:
          await _handleDefaultAction();
      }
    } catch (e) {
      print('Error handling widget interaction: $e');
    }
  }
  
  static Future<void> _handleCameraAction() async {
    // This will be handled by the main app when opened via widget
    await HomeWidget.saveWidgetData<String>('widget_action', 'camera');
    print('Camera action triggered from widget');
  }
  
  static Future<void> _handleGalleryAction() async {
    // This will be handled by the main app when opened via widget
    await HomeWidget.saveWidgetData<String>('widget_action', 'gallery');
    print('Gallery action triggered from widget');
  }
  
  static Future<void> _handleAssistAction() async {
    // This will be handled by the main app when opened via widget
    await HomeWidget.saveWidgetData<String>('widget_action', 'assist');
    print('Assist action triggered from widget');
  }
  
  static Future<void> _handleDefaultAction() async {
    // Open main app
    await HomeWidget.saveWidgetData<String>('widget_action', 'main');
    print('Main app action triggered from widget');
  }
  
  // Get pending widget action
  static Future<String?> getPendingAction() async {
    try {
      final action = await HomeWidget.getWidgetData<String>('widget_action');
      if (action != null && action.isNotEmpty) {
        // Clear the action after retrieving it
        await HomeWidget.saveWidgetData<String>('widget_action', '');
        print('Retrieved widget action: $action');
        return action;
      }
      return null;
    } catch (e) {
      print('Error getting pending action: $e');
      return null;
    }
  }
  
  // Get pending action without clearing it (for checking)
  static Future<String?> peekPendingAction() async {
    try {
      final action = await HomeWidget.getWidgetData<String>('widget_action');
      return (action != null && action.isNotEmpty) ? action : null;
    } catch (e) {
      print('Error peeking pending action: $e');
      return null;
    }
  }
  
  // Save action for after login
  static Future<void> saveActionForLogin(String action) async {
    try {
      await HomeWidget.saveWidgetData<String>('pending_login_action', action);
    } catch (e) {
      print('Error saving action for login: $e');
    }
  }
  
  // Get and clear action saved for after login
  static Future<String?> getPendingLoginAction() async {
    try {
      final action = await HomeWidget.getWidgetData<String>('pending_login_action');
      if (action != null) {
        // Clear the action after retrieving it
        await HomeWidget.saveWidgetData<String>('pending_login_action', '');
      }
      return action;
    } catch (e) {
      print('Error getting pending login action: $e');
      return null;
    }
  }
  
  // Check if widget is available on the platform
  static Future<bool> isWidgetSupported() async {
    try {
      // For Android, widgets are generally supported
      // This is a simplified check - in production you might want more sophisticated detection
      return true;
    } catch (e) {
      print('Error checking widget support: $e');
      return false;
    }
  }
  
  // Request to pin widget to home screen
  static Future<void> requestPinWidget() async {
    try {
      // The home_widget package doesn't have direct pin widget functionality
      // Users need to manually add the widget from their home screen widget picker
      print('Widget is available in the widget picker');
    } catch (e) {
      print('Error requesting pin widget: $e');
    }
  }
} 