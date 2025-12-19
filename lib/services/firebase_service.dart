import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/receipt.dart';

class FirebaseService {
  static FirebaseFirestore? _firestore;
  
  // Initialize Firebase with your project configuration
  static Future<void> initialize() async {
    try {
      debugPrint('🔧 Initializing Firebase...');
      
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCmoK0lVzDXBH4YG0R2DSHYSDvAjREkX4g",
            authDomain: "agentic-ai-day-c4dda.firebaseapp.com",
            projectId: "agentic-ai-day-c4dda",
            storageBucket: "agentic-ai-day-c4dda.appspot.com",
            messagingSenderId: "115110786304604109657",
            appId: "1:115110786304604109657:android:abcdef1234567890",
          ),
        );
      }
      
      _firestore = FirebaseFirestore.instance;
      
      // Configure Firestore settings for better performance
      await _firestore!.enableNetwork();
      
      debugPrint('✅ Firebase initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Firebase: $e');
      rethrow;
    }
  }
  
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _firestore!;
  }
  
  // Fetch all bills from your Firebase 'bills' collection
  static Future<List<Receipt>> fetchBills() async {
    try {
      debugPrint('📱 Fetching bills from Firebase bills collection...');
      
      final QuerySnapshot snapshot = await firestore
          .collection('bills')  // Your collection name
          .orderBy('timestamp', descending: true)
          .get();

      List<Receipt> bills = [];
      
      debugPrint('📊 Found ${snapshot.docs.length} documents in bills collection');
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          debugPrint('📄 Processing document ${doc.id}: ${data.keys.join(', ')}');
          
          // Parse timestamp
          DateTime date;
          if (data['timestamp'] != null) {
            if (data['timestamp'] is Timestamp) {
              date = (data['timestamp'] as Timestamp).toDate();
            } else if (data['timestamp'] is String) {
              date = DateTime.parse(data['timestamp']);
            } else {
              date = DateTime.now();
            }
          } else {
            date = DateTime.now();
          }

          // Parse nextDueDate if exists
          DateTime? nextDueDate;
          if (data['nextDueDate'] != null && data['nextDueDate'] is Timestamp) {
            nextDueDate = (data['nextDueDate'] as Timestamp).toDate();
          }
          
          final receipt = Receipt(
            id: doc.id.hashCode,
            merchantName: data['merchantName']?.toString() ?? 'Unknown Merchant',
            amount: (data['amount'] ?? 0).toDouble(),
            date: date,
            category: data['category']?.toString() ?? 'Other',
            notes: data['notes']?.toString() ?? '',
            imageUrl: data['imageUrl']?.toString(),
            items: data['items'] != null ? List<String>.from(data['items']) : [],
            paymentMethod: data['paymentMethod']?.toString() ?? 'Cash',
            location: data['location']?.toString() ?? '',
            tax: (data['tax'] ?? 0).toDouble(),
            discount: (data['discount'] ?? 0).toDouble(),
            subtotal: (data['subtotal'] ?? 0).toDouble(),
            isRecurring: data['isRecurring'] ?? false,
            frequency: data['frequency']?.toString() ?? '',
            nextDueDate: nextDueDate,
            billStatus: data['billStatus']?.toString() ?? 'paid',
          );
          
          bills.add(receipt);
          debugPrint('✅ Added receipt: ${receipt.merchantName} - \$${receipt.amount}');
        } catch (e) {
          debugPrint('❌ Error parsing document ${doc.id}: $e');
        }
      }
      
      debugPrint('✅ Successfully fetched ${bills.length} bills from Firebase');
      return bills;
      
    } catch (e) {
      debugPrint('❌ Error fetching bills from Firebase: $e');
      return [];
    }
  }

  // Add a new bill to Firebase
  static Future<bool> addBill(Map<String, dynamic> billData) async {
    try {
      // Add timestamp if not present
      if (!billData.containsKey('timestamp')) {
        billData['timestamp'] = Timestamp.now();
      }
      
      final docRef = await firestore.collection('bills').add(billData);
      debugPrint('✅ Bill added successfully with ID: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error adding bill to Firebase: $e');
      return false;
    }
  }

  // Test Firebase connection
  static Future<bool> testConnection() async {
    try {
      await firestore.collection('bills').limit(1).get();
      debugPrint('✅ Firebase connection test successful');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase connection test failed: $e');
      return false;
    }
  }
  
  // Stream bills for real-time updates
  static Stream<List<Receipt>> streamBills() {
    return firestore
        .collection('bills')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      List<Receipt> bills = [];
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          
          DateTime date;
          if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
            date = (data['timestamp'] as Timestamp).toDate();
          } else {
            date = DateTime.now();
          }

          DateTime? nextDueDate;
          if (data['nextDueDate'] != null && data['nextDueDate'] is Timestamp) {
            nextDueDate = (data['nextDueDate'] as Timestamp).toDate();
          }
          
          final receipt = Receipt(
            id: doc.id.hashCode,
            merchantName: data['merchantName']?.toString() ?? 'Unknown Merchant',
            amount: (data['amount'] ?? 0).toDouble(),
            date: date,
            category: data['category']?.toString() ?? 'Other',
            notes: data['notes']?.toString() ?? '',
            imageUrl: data['imageUrl']?.toString(),
            items: data['items'] != null ? List<String>.from(data['items']) : [],
            paymentMethod: data['paymentMethod']?.toString() ?? 'Cash',
            location: data['location']?.toString() ?? '',
            tax: (data['tax'] ?? 0).toDouble(),
            discount: (data['discount'] ?? 0).toDouble(),
            subtotal: (data['subtotal'] ?? 0).toDouble(),
            isRecurring: data['isRecurring'] ?? false,
            frequency: data['frequency']?.toString() ?? '',
            nextDueDate: nextDueDate,
            billStatus: data['billStatus']?.toString() ?? 'paid',
          );
          
          bills.add(receipt);
        } catch (e) {
          debugPrint('❌ Error parsing streamed bill ${doc.id}: $e');
        }
      }
      
      return bills;
    });
  }
} 