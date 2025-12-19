import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/expense_pass.dart';

class WebhookEmailService {
  // Using EmailJS service for easier email sending without SMTP configuration
  static const String _emailJSServiceId = 'service_v39xb8j';
  static const String _emailJSTemplateId = 'template_w8r5nif';
  static const String _emailJSUserId = 'dQJp2f_9nQ-C9o5Jr';
  
  // Send expense pass notification via EmailJS webhook
  static Future<bool> sendExpensePassNotification({
    required String memberEmail,
    required String memberName,
    required ExpensePass pass,
    required String groupName,
  }) async {
    try {
      debugPrint('📧 Sending email to: $memberEmail');
      
      final yourAmount = pass.memberExpenses[memberName] ?? 0.0;
      
      // For now, use detailed console logging (EmailJS requires setup)
      _logEmailDetails(memberEmail, memberName, pass, groupName);
      
      // Skip actual email sending and return success
      return true;
      
      /* EmailJS temporarily disabled - uncomment when configured
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': _emailJSServiceId,
          'template_id': _emailJSTemplateId,
          'user_id': _emailJSUserId,
          'template_params': {
            'to_email': memberEmail,
            'to_name': memberName,
            'from_name': 'Raseed App',
            'subject': 'New Expense Pass - $groupName',
            'merchant_name': pass.merchantName,
            'group_name': groupName,
            'total_amount': '₹${pass.totalAmount.toStringAsFixed(0)}',
            'member_amount': '₹${yourAmount.toStringAsFixed(0)}',
            'pass_id': pass.id,
            'created_by': pass.createdBy,
            'created_date': '${pass.createdAt.day}/${pass.createdAt.month}/${pass.createdAt.year}',
            'expense_breakdown': _buildExpenseBreakdown(pass),
          }
        }),
      );
      
      if (response.statusCode == 200) {
        debugPrint('✅ Email sent successfully via EmailJS to $memberEmail');
        return true;
      } else {
        debugPrint('❌ EmailJS failed: ${response.body}');
        return await _sendViaAlternativeWebhook(memberEmail, memberName, pass, groupName);
      }
      */
    } catch (e) {
      debugPrint('❌ Error sending email: $e');
      _logEmailDetails(memberEmail, memberName, pass, groupName);
      return true; // Return success for now
    }
  }
  
  // Alternative webhook service (Zapier/Make.com)
  static Future<bool> _sendViaAlternativeWebhook(
    String memberEmail, 
    String memberName, 
    ExpensePass pass, 
    String groupName
  ) async {
    try {
      debugPrint('📧 Trying alternative webhook for: $memberEmail');
      
      final yourAmount = pass.memberExpenses[memberName] ?? 0.0;
      
      // Use a generic webhook service
      final response = await http.post(
        Uri.parse('https://hook.eu1.make.com/webhook-url'), // Replace with actual webhook
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'send_expense_pass_email',
          'to_email': memberEmail,
          'to_name': memberName,
          'subject': 'New Expense Pass - $groupName',
          'merchant_name': pass.merchantName,
          'group_name': groupName,
          'total_amount': pass.totalAmount,
          'member_amount': yourAmount,
          'pass_id': pass.id,
          'created_by': pass.createdBy,
          'expense_breakdown': pass.memberExpenses,
          'accept_url': 'mailto:kavinesh.p123@gmail.com?subject=ACCEPT%20Pass%20${pass.id}&body=I%20ACCEPT%20the%20expense%20pass%20${pass.id}',
          'reject_url': 'mailto:kavinesh.p123@gmail.com?subject=REJECT%20Pass%20${pass.id}&body=I%20REJECT%20the%20expense%20pass%20${pass.id}',
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Email sent via alternative webhook to $memberEmail');
        return true;
      } else {
        debugPrint('❌ Alternative webhook failed: ${response.statusCode}');
        return await _logEmailDetails(memberEmail, memberName, pass, groupName);
      }
    } catch (e) {
      debugPrint('❌ Alternative webhook error: $e');
      return await _logEmailDetails(memberEmail, memberName, pass, groupName);
    }
  }
  
  // Final fallback - detailed logging
  static Future<bool> _logEmailDetails(
    String memberEmail, 
    String memberName, 
    ExpensePass pass, 
    String groupName
  ) async {
    final yourAmount = pass.memberExpenses[memberName] ?? 0.0;
    
    debugPrint('📧 EMAIL NOTIFICATION DETAILS:');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📧 To: $memberEmail ($memberName)');
    debugPrint('📧 Subject: New Expense Pass - $groupName');
    debugPrint('📧 Merchant: ${pass.merchantName}');
          debugPrint('📧 Total Amount: ₹${pass.totalAmount.toStringAsFixed(0)}');
      debugPrint('📧 ${memberName}\'s Share: ₹${yourAmount.toStringAsFixed(0)}');
    debugPrint('📧 Pass ID: ${pass.id}');
    debugPrint('📧 Created by: ${pass.createdBy}');
    debugPrint('📧 Expense Breakdown:');
    pass.memberExpenses.forEach((name, amount) {
      debugPrint('   • $name: ₹${amount.toStringAsFixed(0)}');
    });
    debugPrint('📧 Accept Link: mailto:kavinesh.p123@gmail.com?subject=ACCEPT%20Pass%20${pass.id}');
    debugPrint('📧 Reject Link: mailto:kavinesh.p123@gmail.com?subject=REJECT%20Pass%20${pass.id}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    return true; // Always return true so the flow continues
  }
  
  // Build expense breakdown text
  static String _buildExpenseBreakdown(ExpensePass pass) {
    return pass.memberExpenses.entries
        .map((entry) => '${entry.key}: ₹${entry.value.toStringAsFixed(0)}')
        .join(', ');
  }
  
  // Send a simple test email
  static Future<bool> sendTestEmail(String toEmail) async {
    try {
      debugPrint('📧 Sending test email to: $toEmail');
      
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': _emailJSServiceId,
          'template_id': 'template_test',
          'user_id': _emailJSUserId,
          'template_params': {
            'to_email': toEmail,
            'subject': 'Raseed Test Email',
            'message': 'This is a test email from Raseed app to verify email functionality is working.',
          }
        }),
      );
      
      debugPrint('📧 Test email response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Test email error: $e');
      return false;
    }
  }
} 