import 'package:flutter/material.dart';
import '../models/family_group.dart';
import '../models/receipt.dart';
import '../models/expense_pass.dart';

class FamilyProvider extends ChangeNotifier {
  List<FamilyGroup> _familyGroups = [];
  FamilyGroup? _selectedGroup;
  List<ExpensePass> _expensePasses = [];

  // Getters
  List<FamilyGroup> get familyGroups => _familyGroups;
  FamilyGroup? get selectedGroup => _selectedGroup;
  bool get hasGroups => _familyGroups.isNotEmpty;
  List<ExpensePass> get expensePasses => _expensePasses;
  
  // Get expense passes for a specific group
  List<ExpensePass> getExpensePassesForGroup(String groupId) {
    return _expensePasses.where((pass) => pass.groupId == groupId).toList();
  }
  
  // Get pending expense passes for a specific member
  List<ExpensePass> getPendingPassesForMember(String memberName) {
    return _expensePasses.where((pass) => 
      pass.status == ExpensePassStatus.pending &&
      pass.memberExpenses.containsKey(memberName) &&
      !pass.acceptedBy.contains(memberName) &&
      !pass.rejectedBy.contains(memberName)
    ).toList();
  }

  // Initialize with some demo data
  FamilyProvider() {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    // Create demo groups for testing
    final currentUser = GroupMember(
      id: 'user1',
      name: 'You',
      email: 'kavinesh.p123@gmail.com',
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      isAdmin: true,
    );

    final demoGroup1 = FamilyGroup(
      id: 'group1',
      name: 'Johnson Family',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      members: [
        currentUser,
        GroupMember(
          id: 'user2',
          name: 'Sarah Johnson',
          email: 'sarah.j@gmail.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        GroupMember(
          id: 'user3',
          name: 'Mike Johnson',
          email: 'mike.j@gmail.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
        GroupMember(
          id: 'user4',
          name: 'Emma Johnson',
          email: 'emma.j@gmail.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        GroupMember(
          id: 'user5',
          name: 'Tom Johnson',
          email: 'tom.j@gmail.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        GroupMember(
          id: 'user6',
          name: 'Hygrevan',
          email: 'hygrevan@gmail.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      sharedReceiptIds: ['receipt1', 'receipt2'],
    );

    final demoGroup2 = FamilyGroup(
      id: 'group2',
      name: 'Office Team',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      members: [
        currentUser,
        GroupMember(
          id: 'user6',
          name: 'John Smith',
          email: 'john.smith@company.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        GroupMember(
          id: 'user7',
          name: 'Lisa Davis',
          email: 'lisa.davis@company.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
        GroupMember(
          id: 'user8',
          name: 'Alex Chen',
          email: 'alex.chen@company.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        GroupMember(
          id: 'user9',
          name: 'Maria Garcia',
          email: 'maria.garcia@company.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        GroupMember(
          id: 'user10',
          name: 'David Wilson',
          email: 'david.wilson@company.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        GroupMember(
          id: 'user11',
          name: 'Jennifer Brown',
          email: 'jennifer.brown@company.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      sharedReceiptIds: ['receipt3'],
    );

    _familyGroups = [demoGroup1, demoGroup2];
  }

  // Create new family group
  void createGroup(String groupName) {
    final currentUser = GroupMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'You',
      email: 'kavinesh.p123@gmail.com',
      joinedAt: DateTime.now(),
      isAdmin: true,
    );

    final newGroup = FamilyGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: groupName,
      createdAt: DateTime.now(),
      members: [currentUser],
      sharedReceiptIds: [],
    );

    _familyGroups.add(newGroup);
    notifyListeners();
  }

  // Select a group for viewing details
  void selectGroup(FamilyGroup group) {
    _selectedGroup = group;
    notifyListeners();
  }

  // Clear selected group
  void clearSelectedGroup() {
    _selectedGroup = null;
    notifyListeners();
  }

  // Add member to group
  void addMemberToGroup(String groupId, String memberName, String memberEmail) {
    final groupIndex = _familyGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      final newMember = GroupMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: memberName,
        email: memberEmail,
        joinedAt: DateTime.now(),
      );

      _familyGroups[groupIndex] = _familyGroups[groupIndex].addMember(newMember);
      
      // Update selected group if it's the same group
      if (_selectedGroup?.id == groupId) {
        _selectedGroup = _familyGroups[groupIndex];
      }
      
      notifyListeners();
    }
  }

  // Add receipt to group
  void addReceiptToGroup(String groupId, String receiptId) {
    final groupIndex = _familyGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      _familyGroups[groupIndex] = _familyGroups[groupIndex].addReceipt(receiptId);
      
      // Update selected group if it's the same group
      if (_selectedGroup?.id == groupId) {
        _selectedGroup = _familyGroups[groupIndex];
      }
      
      notifyListeners();
    }
  }

  // Remove receipt from group
  void removeReceiptFromGroup(String groupId, String receiptId) {
    final groupIndex = _familyGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      _familyGroups[groupIndex] = _familyGroups[groupIndex].removeReceipt(receiptId);
      
      // Update selected group if it's the same group
      if (_selectedGroup?.id == groupId) {
        _selectedGroup = _familyGroups[groupIndex];
      }
      
      notifyListeners();
    }
  }

  // Get shared receipts for a group (this would normally fetch from a service)
  List<Receipt> getSharedReceiptsForGroup(String groupId) {
    final group = _familyGroups.firstWhere((group) => group.id == groupId);
    // For now, return empty list - in real app, would fetch actual receipts
    // based on the sharedReceiptIds
    return [];
  }

  // Delete group
  void deleteGroup(String groupId) {
    _familyGroups.removeWhere((group) => group.id == groupId);
    if (_selectedGroup?.id == groupId) {
      _selectedGroup = null;
    }
    notifyListeners();
  }
  
  // Add expense pass
  void addExpensePass(ExpensePass pass) {
    _expensePasses.add(pass);
    notifyListeners();
  }
  
  // Accept expense pass for a member
  void acceptExpensePass(String passId, String memberName) {
    final passIndex = _expensePasses.indexWhere((pass) => pass.id == passId);
    if (passIndex != -1) {
      _expensePasses[passIndex] = _expensePasses[passIndex].acceptByMember(memberName);
      notifyListeners();
    }
  }
  
  // Reject expense pass for a member
  void rejectExpensePass(String passId, String memberName) {
    final passIndex = _expensePasses.indexWhere((pass) => pass.id == passId);
    if (passIndex != -1) {
      _expensePasses[passIndex] = _expensePasses[passIndex].rejectByMember(memberName);
      notifyListeners();
    }
  }
  
  // Get expense pass by ID
  ExpensePass? getExpensePassById(String passId) {
    try {
      return _expensePasses.firstWhere((pass) => pass.id == passId);
    } catch (e) {
      return null;
    }
  }
  
  // Update expense pass status
  void updateExpensePassStatus(String passId, ExpensePassStatus status) {
    final passIndex = _expensePasses.indexWhere((pass) => pass.id == passId);
    if (passIndex != -1) {
      final pass = _expensePasses[passIndex];
      _expensePasses[passIndex] = ExpensePass(
        id: pass.id,
        groupId: pass.groupId,
        merchantName: pass.merchantName,
        totalAmount: pass.totalAmount,
        memberExpenses: pass.memberExpenses,
        createdBy: pass.createdBy,
        createdAt: pass.createdAt,
        status: status,
        acceptedBy: pass.acceptedBy,
        rejectedBy: pass.rejectedBy,
        notes: pass.notes,
      );
      notifyListeners();
    }
  }
} 