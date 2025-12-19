class ExpensePass {
  final String id;
  final String groupId;
  final String merchantName;
  final double totalAmount;
  final Map<String, double> memberExpenses; // Member name -> amount owed
  final String createdBy;
  final DateTime createdAt;
  final ExpensePassStatus status;
  final List<String> acceptedBy;
  final List<String> rejectedBy;
  final String? notes;

  ExpensePass({
    required this.id,
    required this.groupId,
    required this.merchantName,
    required this.totalAmount,
    required this.memberExpenses,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    this.acceptedBy = const [],
    this.rejectedBy = const [],
    this.notes,
  });

  // Get total accepted amount
  double get acceptedAmount {
    return acceptedBy.fold(0.0, (sum, memberName) {
      return sum + (memberExpenses[memberName] ?? 0.0);
    });
  }

  // Get total rejected amount
  double get rejectedAmount {
    return rejectedBy.fold(0.0, (sum, memberName) {
      return sum + (memberExpenses[memberName] ?? 0.0);
    });
  }

  // Get pending amount
  double get pendingAmount {
    return totalAmount - acceptedAmount - rejectedAmount;
  }

  // Check if all members have responded
  bool get isFullyResponded {
    final totalMembers = memberExpenses.keys.length;
    return (acceptedBy.length + rejectedBy.length) >= totalMembers;
  }

  // Check if pass is fully accepted
  bool get isFullyAccepted {
    return acceptedBy.length == memberExpenses.keys.length;
  }

  // Accept the pass for a member
  ExpensePass acceptByMember(String memberName) {
    if (rejectedBy.contains(memberName)) {
      // Remove from rejected list if previously rejected
      return ExpensePass(
        id: id,
        groupId: groupId,
        merchantName: merchantName,
        totalAmount: totalAmount,
        memberExpenses: memberExpenses,
        createdBy: createdBy,
        createdAt: createdAt,
        status: isFullyAccepted ? ExpensePassStatus.accepted : ExpensePassStatus.pending,
        acceptedBy: [...acceptedBy, memberName],
        rejectedBy: rejectedBy.where((name) => name != memberName).toList(),
        notes: notes,
      );
    } else if (!acceptedBy.contains(memberName)) {
      final newAcceptedBy = [...acceptedBy, memberName];
      return ExpensePass(
        id: id,
        groupId: groupId,
        merchantName: merchantName,
        totalAmount: totalAmount,
        memberExpenses: memberExpenses,
        createdBy: createdBy,
        createdAt: createdAt,
        status: newAcceptedBy.length == memberExpenses.keys.length 
            ? ExpensePassStatus.accepted 
            : ExpensePassStatus.pending,
        acceptedBy: newAcceptedBy,
        rejectedBy: rejectedBy,
        notes: notes,
      );
    }
    return this;
  }

  // Reject the pass for a member
  ExpensePass rejectByMember(String memberName) {
    if (acceptedBy.contains(memberName)) {
      // Remove from accepted list if previously accepted
      return ExpensePass(
        id: id,
        groupId: groupId,
        merchantName: merchantName,
        totalAmount: totalAmount,
        memberExpenses: memberExpenses,
        createdBy: createdBy,
        createdAt: createdAt,
        status: ExpensePassStatus.pending,
        acceptedBy: acceptedBy.where((name) => name != memberName).toList(),
        rejectedBy: [...rejectedBy, memberName],
        notes: notes,
      );
    } else if (!rejectedBy.contains(memberName)) {
      return ExpensePass(
        id: id,
        groupId: groupId,
        merchantName: merchantName,
        totalAmount: totalAmount,
        memberExpenses: memberExpenses,
        createdBy: createdBy,
        createdAt: createdAt,
        status: ExpensePassStatus.pending,
        acceptedBy: acceptedBy,
        rejectedBy: [...rejectedBy, memberName],
        notes: notes,
      );
    }
    return this;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'merchantName': merchantName,
      'totalAmount': totalAmount,
      'memberExpenses': memberExpenses,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
      'acceptedBy': acceptedBy,
      'rejectedBy': rejectedBy,
      'notes': notes,
    };
  }

  // Create from JSON
  factory ExpensePass.fromJson(Map<String, dynamic> json) {
    return ExpensePass(
      id: json['id'],
      groupId: json['groupId'],
      merchantName: json['merchantName'],
      totalAmount: json['totalAmount'].toDouble(),
      memberExpenses: Map<String, double>.from(
        json['memberExpenses'].map((key, value) => MapEntry(key, value.toDouble())),
      ),
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      status: ExpensePassStatus.values.firstWhere(
        (status) => status.toString() == json['status'],
        orElse: () => ExpensePassStatus.pending,
      ),
      acceptedBy: List<String>.from(json['acceptedBy'] ?? []),
      rejectedBy: List<String>.from(json['rejectedBy'] ?? []),
      notes: json['notes'],
    );
  }
}

enum ExpensePassStatus {
  pending,
  accepted,
  rejected,
  expired,
}

extension ExpensePassStatusExtension on ExpensePassStatus {
  String get displayName {
    switch (this) {
      case ExpensePassStatus.pending:
        return 'Pending';
      case ExpensePassStatus.accepted:
        return 'Accepted';
      case ExpensePassStatus.rejected:
        return 'Rejected';
      case ExpensePassStatus.expired:
        return 'Expired';
    }
  }

  String get description {
    switch (this) {
      case ExpensePassStatus.pending:
        return 'Waiting for group members to respond';
      case ExpensePassStatus.accepted:
        return 'All members have accepted the expense split';
      case ExpensePassStatus.rejected:
        return 'One or more members have rejected the expense split';
      case ExpensePassStatus.expired:
        return 'The expense pass has expired';
    }
  }
} 