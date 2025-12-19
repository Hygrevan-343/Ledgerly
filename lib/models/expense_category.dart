import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;
  final String id;

  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
    required this.id,
  });

  // Mock constructor for sample data
  ExpenseCategory.mock({
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
    required this.id,
  });

  // Predefined categories with colors and icons
  static ExpenseCategory retailShopping() => ExpenseCategory.mock(
        id: 'retail_shopping',
        name: 'Retail / Shopping',
        amount: 8500,
        color: const Color(0xFF9C27B0), // Purple
        icon: Icons.shopping_bag,
      );

  static ExpenseCategory foodDining() => ExpenseCategory.mock(
        id: 'food_dining',
        name: 'Food & Dining',
        amount: 6200,
        color: const Color(0xFFFF9800), // Orange
        icon: Icons.restaurant,
      );

  static ExpenseCategory travelTransportation() => ExpenseCategory.mock(
        id: 'travel_transportation',
        name: 'Travel / Transportation',
        amount: 3400,
        color: const Color(0xFF4CAF50), // Green
        icon: Icons.flight_takeoff,
      );

  static ExpenseCategory utilityBills() => ExpenseCategory.mock(
        id: 'utility_bills',
        name: 'Utility Bills',
        amount: 2850,
        color: const Color(0xFF2196F3), // Blue
        icon: Icons.electrical_services,
      );

  static ExpenseCategory subscriptions() => ExpenseCategory.mock(
        id: 'subscriptions',
        name: 'Subscription Services',
        amount: 1250,
        color: const Color(0xFF607D8B), // Blue Grey
        icon: Icons.subscriptions,
      );

  static ExpenseCategory medicalPharmacy() => ExpenseCategory.mock(
        id: 'medical_pharmacy',
        name: 'Medical / Pharmacy',
        amount: 1850,
        color: const Color(0xFFF44336), // Red
        icon: Icons.local_pharmacy,
      );

  static ExpenseCategory educationTuition() => ExpenseCategory.mock(
        id: 'education_tuition',
        name: 'Education / Tuition',
        amount: 28000,
        color: const Color(0xFF795548), // Brown
        icon: Icons.school,
      );

  // Get percentage of total spending
  double getPercentage(double totalSpending) {
    if (totalSpending == 0) return 0;
    return (amount / totalSpending) * 100;
  }

  // Copy with method for updates
  ExpenseCategory copyWith({
    String? name,
    double? amount,
    Color? color,
    IconData? icon,
    String? id,
  }) {
    return ExpenseCategory(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      id: id ?? this.id,
    );
  }
} 