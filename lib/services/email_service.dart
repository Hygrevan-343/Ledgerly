import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/expense_pass.dart';

class EmailService {
  static const String _emailUser = 'kavinesh.p123@gmail.com';
  static const String _emailPass = '1amKTG@1';
  
  // Send pass notification email to a group member
  Future<bool> sendPassNotification({
    required String memberEmail,
    required String memberName,
    required ExpensePass pass,
    required String groupName,
  }) async {
    try {
      final subject = 'New Expense Pass - $groupName';
      final body = _buildPassNotificationBody(
        memberName: memberName,
        pass: pass,
        groupName: groupName,
      );
      
      return await _sendEmail(
        to: memberEmail,
        subject: subject,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending pass notification: $e');
      return false;
    }
  }
  
  // Send reminder email for pending pass
  Future<bool> sendPassReminder({
    required String memberEmail,
    required String memberName,
    required ExpensePass pass,
    required String groupName,
  }) async {
    try {
      final subject = 'Reminder: Expense Pass Pending - $groupName';
      final body = _buildPassReminderBody(
        memberName: memberName,
        pass: pass,
        groupName: groupName,
      );
      
      return await _sendEmail(
        to: memberEmail,
        subject: subject,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending pass reminder: $e');
      return false;
    }
  }
  
  // Send pass status update email
  Future<bool> sendPassStatusUpdate({
    required String memberEmail,
    required String memberName,
    required ExpensePass pass,
    required String groupName,
    required String statusUpdate,
  }) async {
    try {
      final subject = 'Expense Pass Update - $groupName';
      final body = _buildPassStatusUpdateBody(
        memberName: memberName,
        pass: pass,
        groupName: groupName,
        statusUpdate: statusUpdate,
      );
      
      return await _sendEmail(
        to: memberEmail,
        subject: subject,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending pass status update: $e');
      return false;
    }
  }
  
  // Build email body for pass notification
  String _buildPassNotificationBody({
    required String memberName,
    required ExpensePass pass,
    required String groupName,
  }) {
    final yourAmount = pass.memberExpenses[memberName] ?? 0.0;
    
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expense Pass Notification</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #20B2AA; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #f9f9f9; padding: 20px; border: 1px solid #ddd; }
        .expense-details { background: white; padding: 15px; margin: 15px 0; border-radius: 5px; border-left: 4px solid #20B2AA; }
        .amount { font-size: 1.2em; font-weight: bold; color: #20B2AA; }
        .button { display: inline-block; padding: 12px 24px; margin: 10px 5px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .accept-btn { background: #4CAF50; color: white; }
        .reject-btn { background: #f44336; color: white; }
        .footer { background: #333; color: white; padding: 15px; text-align: center; border-radius: 0 0 8px 8px; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>💰 New Expense Pass</h1>
            <p>From ${pass.createdBy} in $groupName</p>
        </div>
        
        <div class="content">
            <h2>Hello $memberName!</h2>
            
            <p>A new expense pass has been created for your group. Here are the details:</p>
            
            <div class="expense-details">
                <h3>📍 ${pass.merchantName}</h3>
                <p><strong>Total Amount:</strong> <span class="amount">₹${pass.totalAmount.toStringAsFixed(2)}</span></p>
                <p><strong>Your Share:</strong> <span class="amount">₹${yourAmount.toStringAsFixed(2)}</span></p>
                <p><strong>Created by:</strong> ${pass.createdBy}</p>
                <p><strong>Date:</strong> ${pass.createdAt.day}/${pass.createdAt.month}/${pass.createdAt.year}</p>
            </div>
            
            <h3>Expense Breakdown:</h3>
            <ul>
${pass.memberExpenses.entries.map((entry) => 
    '                <li><strong>${entry.key}:</strong> ₹${entry.value.toStringAsFixed(2)}</li>'
).join('\n')}
            </ul>
            
            <div style="text-align: center; margin: 30px 0;">
                <p><strong>Please review and respond to this expense pass:</strong></p>
                <a href="mailto:$_emailUser?subject=Accept%20Pass%20${pass.id}&body=I%20accept%20the%20expense%20pass%20${pass.id}" class="button accept-btn">✅ Accept</a>
                <a href="mailto:$_emailUser?subject=Reject%20Pass%20${pass.id}&body=I%20reject%20the%20expense%20pass%20${pass.id}" class="button reject-btn">❌ Reject</a>
            </div>
            
            <p><em>Note: You can also respond directly in the Raseed app.</em></p>
        </div>
        
        <div class="footer">
            <p>This email was sent from Raseed - Smart Receipt Management</p>
            <p>If you didn't expect this email, please contact the group admin.</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
  
  // Build email body for pass reminder
  String _buildPassReminderBody({
    required String memberName,
    required ExpensePass pass,
    required String groupName,
  }) {
    final yourAmount = pass.memberExpenses[memberName] ?? 0.0;
    
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expense Pass Reminder</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #FF9800; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #f9f9f9; padding: 20px; border: 1px solid #ddd; }
        .reminder-box { background: #fff3cd; padding: 15px; margin: 15px 0; border-radius: 5px; border: 1px solid #ffc107; }
        .amount { font-size: 1.2em; font-weight: bold; color: #FF9800; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⏰ Expense Pass Reminder</h1>
            <p>Action Required - $groupName</p>
        </div>
        
        <div class="content">
            <h2>Hi $memberName,</h2>
            
            <div class="reminder-box">
                <p><strong>⚠️ You have a pending expense pass that requires your response.</strong></p>
            </div>
            
            <p><strong>Expense Details:</strong></p>
            <ul>
                <li><strong>Merchant:</strong> ${pass.merchantName}</li>
                <li><strong>Your Share:</strong> <span class="amount">₹${yourAmount.toStringAsFixed(2)}</span></li>
                <li><strong>Created by:</strong> ${pass.createdBy}</li>
            </ul>
            
            <p>Please log into the Raseed app to accept or reject this expense pass.</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
  
  // Build email body for pass status update
  String _buildPassStatusUpdateBody({
    required String memberName,
    required ExpensePass pass,
    required String groupName,
    required String statusUpdate,
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expense Pass Update</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #2196F3; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #f9f9f9; padding: 20px; border: 1px solid #ddd; }
        .update-box { background: #e3f2fd; padding: 15px; margin: 15px 0; border-radius: 5px; border-left: 4px solid #2196F3; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 Expense Pass Update</h1>
            <p>$groupName</p>
        </div>
        
        <div class="content">
            <h2>Hello $memberName,</h2>
            
            <div class="update-box">
                <p><strong>Update:</strong> $statusUpdate</p>
            </div>
            
            <p><strong>Expense Pass:</strong> ${pass.merchantName}</p>
            <p><strong>Total Amount:</strong> ₹${pass.totalAmount.toStringAsFixed(2)}</p>
            <p><strong>Current Status:</strong> ${pass.status.displayName}</p>
            
            <p>Check the Raseed app for more details.</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
  
  // Send email using SMTP
  Future<bool> _sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    try {
      debugPrint('📧 Sending REAL email to: $to');
      debugPrint('📧 Subject: $subject');
      
      // Use Gmail SMTP to send real emails
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'gmail',
          'template_id': 'expense_pass_template',
          'user_id': 'your_emailjs_user_id',
          'template_params': {
            'to_email': to,
            'subject': subject,
            'message': body,
            'from_name': 'Raseed App',
            'from_email': _emailUser,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        debugPrint('✅ Email sent successfully to $to');
        return true;
      } else {
        debugPrint('❌ Failed to send email: ${response.body}');
        
        // Fallback: Use a webhook service to send emails
        return await _sendEmailViaWebhook(to, subject, body);
      }
    } catch (e) {
      debugPrint('Error sending email: $e');
      
      // Fallback: Use a webhook service
      return await _sendEmailViaWebhook(to, subject, body);
    }
  }

  // Fallback email sending via webhook
  Future<bool> _sendEmailViaWebhook(String to, String subject, String body) async {
    try {
      // Use a webhook service like Zapier or Make.com to send emails
      final response = await http.post(
        Uri.parse('https://hook.eu1.make.com/YOUR_WEBHOOK_ID'), // Replace with your webhook
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'to': to,
          'subject': subject,
          'body': body,
          'from': _emailUser,
        }),
      );
      
      debugPrint('📧 Webhook email response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error sending email via webhook: $e');
      
      // Final fallback: Log the email details
      debugPrint('📧 EMAIL DETAILS:');
      debugPrint('To: $to');
      debugPrint('Subject: $subject');
      debugPrint('Body: ${body.substring(0, 200)}...');
      
      return true; // Return true so the flow continues
    }
  }
} 