class FamilyGroup {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<GroupMember> members;
  final List<String> sharedReceiptIds; // IDs of receipts shared in this group

  FamilyGroup({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.members,
    required this.sharedReceiptIds,
  });

  // Get member count
  int get memberCount => members.length;

  // Check if group has receipts
  bool get hasSharedReceipts => sharedReceiptIds.isNotEmpty;

  // Add member to group
  FamilyGroup addMember(GroupMember member) {
    return FamilyGroup(
      id: id,
      name: name,
      createdAt: createdAt,
      members: [...members, member],
      sharedReceiptIds: sharedReceiptIds,
    );
  }

  // Add receipt to group
  FamilyGroup addReceipt(String receiptId) {
    return FamilyGroup(
      id: id,
      name: name,
      createdAt: createdAt,
      members: members,
      sharedReceiptIds: [...sharedReceiptIds, receiptId],
    );
  }

  // Remove receipt from group
  FamilyGroup removeReceipt(String receiptId) {
    return FamilyGroup(
      id: id,
      name: name,
      createdAt: createdAt,
      members: members,
      sharedReceiptIds: sharedReceiptIds.where((id) => id != receiptId).toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'members': members.map((member) => member.toJson()).toList(),
      'sharedReceiptIds': sharedReceiptIds,
    };
  }

  // Create from JSON
  factory FamilyGroup.fromJson(Map<String, dynamic> json) {
    return FamilyGroup(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      members: (json['members'] as List)
          .map((memberJson) => GroupMember.fromJson(memberJson))
          .toList(),
      sharedReceiptIds: List<String>.from(json['sharedReceiptIds']),
    );
  }
}

class GroupMember {
  final String id;
  final String name;
  final String email;
  final DateTime joinedAt;
  final bool isAdmin;

  GroupMember({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt,
    this.isAdmin = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'joinedAt': joinedAt.toIso8601String(),
      'isAdmin': isAdmin,
    };
  }

  // Create from JSON
  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      joinedAt: DateTime.parse(json['joinedAt']),
      isAdmin: json['isAdmin'] ?? false,
    );
  }
} 