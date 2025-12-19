class Receipt {
  final int? id;
  final String merchantName;
  final double amount;
  final DateTime date;
  final String category;
  final String? imagePath;
  final String? imageUrl; // Firebase image URL
  final String? notes;
  // Recurring payment properties
  final bool isRecurring;
  final String? frequency; // 'weekly', 'monthly', 'quarterly', 'yearly'
  final DateTime? nextDueDate;
  final String? billStatus; // 'active', 'inactive', 'overdue', 'paid'
  // Additional Firebase fields
  final List<String> items;
  final String paymentMethod;
  final String location;
  final double tax;
  final double discount;
  final double subtotal;

  Receipt({
    this.id,
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.category,
    this.imagePath,
    this.imageUrl,
    this.notes,
    this.isRecurring = false,
    this.frequency,
    this.nextDueDate,
    this.billStatus,
    this.items = const [],
    this.paymentMethod = 'Cash',
    this.location = '',
    this.tax = 0.0,
    this.discount = 0.0,
    this.subtotal = 0.0,
  });

  // Mock constructor for sample data
  Receipt.mock({
    this.id,
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.category,
    this.imagePath,
    this.imageUrl,
    this.notes,
    this.isRecurring = false,
    this.frequency,
    this.nextDueDate,
    this.billStatus,
    this.items = const [],
    this.paymentMethod = 'Cash',
    this.location = '',
    this.tax = 0.0,
    this.discount = 0.0,
    this.subtotal = 0.0,
  });

  // Factory for creating from JSON (for future API integration)
  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      merchantName: json['merchantName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      category: json['category'] ?? 'Other',
      imagePath: json['imagePath'],
      imageUrl: json['imageUrl'],
      notes: json['notes'],
      isRecurring: json['isRecurring'] ?? false,
      frequency: json['frequency'],
      nextDueDate: json['nextDueDate'] != null 
          ? DateTime.parse(json['nextDueDate']) 
          : null,
      billStatus: json['billStatus'],
      items: List<String>.from(json['items'] ?? []),
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      location: json['location'] ?? '',
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'notes': notes,
      'isRecurring': isRecurring,
      'frequency': frequency,
      'nextDueDate': nextDueDate?.toIso8601String(),
      'billStatus': billStatus,
      'items': items,
      'paymentMethod': paymentMethod,
      'location': location,
      'tax': tax,
      'discount': discount,
      'subtotal': subtotal,
    };
  }

  // Copy with method for updates
  Receipt copyWith({
    int? id,
    String? merchantName,
    double? amount,
    DateTime? date,
    String? category,
    String? imagePath,
    String? imageUrl,
    String? notes,
    bool? isRecurring,
    String? frequency,
    DateTime? nextDueDate,
    String? billStatus,
    List<String>? items,
    String? paymentMethod,
    String? location,
    double? tax,
    double? discount,
    double? subtotal,
  }) {
    return Receipt(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      billStatus: billStatus ?? this.billStatus,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      location: location ?? this.location,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  // Helper methods for recurring bills
  bool get isOverdue {
    if (!isRecurring || nextDueDate == null) return false;
    return DateTime.now().isAfter(nextDueDate!);
  }

  bool get isUpcoming {
    if (!isRecurring || nextDueDate == null) return false;
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return nextDueDate!.isAfter(now) && nextDueDate!.isBefore(weekFromNow);
  }

  bool get isRecentlyPaid {
    if (!isRecurring) return false;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return billStatus == 'paid' && date.isAfter(weekAgo);
  }
} 