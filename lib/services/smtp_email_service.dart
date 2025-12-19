import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/foundation.dart';
import '../models/expense_pass.dart';

class SMTPEmailService {
  static const String _emailUser = 'kavinesh.p123@gmail.com';
  static const String _emailPass = 'nbuf iqcm rrpx wqvx'; // Gmail App Password (replace with your actual app password)
  
  // Send expense pass notification via SMTP
  static Future<bool> sendExpensePassNotification({
    required String memberEmail,
    required String memberName,
    required ExpensePass pass,
    required String groupName,
  }) async {
    try {
      debugPrint('📧 Sending REAL email via SMTP to: $memberEmail');
      
      // Configure SMTP server (Gmail)
      final smtpServer = gmail(_emailUser, _emailPass);
      
      // Create the email message
      final message = Message()
        ..from = Address(_emailUser, 'Raseed App')
        ..recipients.add(memberEmail)
        ..subject = 'New Expense Pass - $groupName'
        ..html = _buildEmailBody(memberName, pass, groupName);
      
      // Send the email
      final sendReport = await send(message, smtpServer);
      
      debugPrint('✅ Email sent successfully to $memberEmail');
      debugPrint('📧 Message ID: ${sendReport.mail}');
      
      return true;
    } catch (e) {
      debugPrint('❌ Error sending email: $e');
      
      // Fallback: Log the email details
      debugPrint('📧 FALLBACK - Email details logged:');
      debugPrint('To: $memberEmail');
      debugPrint('Subject: New Expense Pass - $groupName');
      debugPrint('Pass ID: ${pass.id}');
      debugPrint('Amount: ₹${pass.totalAmount}');
      
      return false;
    }
  }
  
  // Build HTML email body
  static String _buildEmailBody(String memberName, ExpensePass pass, String groupName) {
    final yourAmount = pass.memberExpenses[memberName] ?? 0.0;
    
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expense Pass Notification</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            line-height: 1.6; 
            color: #333; 
            margin: 0; 
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container { 
            max-width: 600px; 
            margin: 0 auto; 
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .header { 
            background: linear-gradient(135deg, #20B2AA, #17a2b8); 
            color: white; 
            padding: 30px 20px; 
            text-align: center; 
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        .content { 
            padding: 30px 20px; 
        }
        .expense-details { 
            background: #f8f9fa; 
            padding: 20px; 
            margin: 20px 0; 
            border-radius: 8px; 
            border-left: 4px solid #20B2AA; 
        }
        .amount { 
            font-size: 24px; 
            font-weight: bold; 
            color: #20B2AA; 
        }
        .button-container {
            text-align: center;
            margin: 30px 0;
        }
        .button { 
            display: inline-block; 
            padding: 12px 30px; 
            margin: 10px; 
            text-decoration: none; 
            border-radius: 25px; 
            font-weight: bold; 
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .accept-btn { 
            background: #28a745; 
            color: white; 
        }
        .accept-btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        .reject-btn { 
            background: #dc3545; 
            color: white; 
        }
        .reject-btn:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        .footer { 
            background: #343a40; 
            color: white; 
            padding: 20px; 
            text-align: center; 
            font-size: 14px; 
        }
        .member-list {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            margin: 15px 0;
        }
        .member-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .member-item:last-child {
            border-bottom: none;
        }
        .highlight {
            background: linear-gradient(45deg, #20B2AA, #17a2b8);
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>💰 Expense Pass Created!</h1>
            <p style="margin: 10px 0 0 0; font-size: 18px;">From $groupName</p>
        </div>
        
        <div class="content">
            <h2 style="color: #20B2AA;">Hello $memberName! 👋</h2>
            
            <p style="font-size: 16px;">A new expense pass has been created for your group. Here are the details:</p>
            
            <div class="expense-details">
                <h3 style="margin-top: 0; color: #343a40;">📍 ${pass.merchantName}</h3>
                <div style="display: flex; justify-content: space-between; align-items: center; margin: 15px 0;">
                    <span style="font-size: 18px; font-weight: 500;">Total Amount:</span>
                    <span class="amount">₹${pass.totalAmount.toStringAsFixed(2)}</span>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin: 15px 0;">
                    <span style="font-size: 18px; font-weight: 500;">Your Share:</span>
                    <span class="amount highlight">₹${yourAmount.toStringAsFixed(2)}</span>
                </div>
                <p><strong>Created by:</strong> ${pass.createdBy}</p>
                <p><strong>Date:</strong> ${pass.createdAt.day}/${pass.createdAt.month}/${pass.createdAt.year}</p>
            </div>
            
            <h3 style="color: #343a40;">💳 Expense Breakdown:</h3>
            <div class="member-list">
${pass.memberExpenses.entries.map((entry) => 
    '                <div class="member-item"><span><strong>${entry.key}</strong></span><span class="amount">₹${entry.value.toStringAsFixed(2)}</span></div>'
).join('\n')}
            </div>
            
            <div class="button-container">
                <p style="font-size: 18px; font-weight: 500; margin-bottom: 20px;">Please review and respond:</p>
                <a href="mailto:$_emailUser?subject=ACCEPT%20Pass%20${pass.id}&body=I%20ACCEPT%20the%20expense%20pass%20${pass.id}%20for%20₹${yourAmount.toStringAsFixed(2)}" class="button accept-btn">✅ Accept Pass</a>
                <a href="mailto:$_emailUser?subject=REJECT%20Pass%20${pass.id}&body=I%20REJECT%20the%20expense%20pass%20${pass.id}%20for%20₹${yourAmount.toStringAsFixed(2)}" class="button reject-btn">❌ Reject Pass</a>
            </div>
            
            <div style="background: #e3f2fd; padding: 15px; border-radius: 6px; margin: 20px 0;">
                <p style="margin: 0; font-size: 14px; color: #1565c0;">
                    <strong>💡 Tip:</strong> You can also respond directly in the Raseed app or reply to this email with "ACCEPT" or "REJECT".
                </p>
            </div>
        </div>
        
        <div class="footer">
            <p style="margin: 0 0 10px 0; font-weight: bold;">📱 Raseed - Smart Receipt Management</p>
            <p style="margin: 0; opacity: 0.8;">This email was generated automatically. If you didn't expect this, please contact the group admin.</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
  
  // Send a simple notification email
  static Future<bool> sendSimpleNotification({
    required String to,
    required String subject,
    required String message,
  }) async {
    try {
      debugPrint('📧 Sending simple notification to: $to');
      
      final smtpServer = gmail(_emailUser, _emailPass);
      
      final emailMessage = Message()
        ..from = Address(_emailUser, 'Raseed App')
        ..recipients.add(to)
        ..subject = subject
        ..text = message;
      
      await send(emailMessage, smtpServer);
      debugPrint('✅ Simple notification sent successfully');
      
      return true;
    } catch (e) {
      debugPrint('❌ Error sending simple notification: $e');
      return false;
    }
  }
} 