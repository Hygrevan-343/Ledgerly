import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../models/family_group.dart';
import '../models/receipt.dart';
import '../services/mock_data_service.dart';
import '../services/twilio_service.dart';
import '../widgets/expense_pass_popup.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class FamilyHubScreen extends StatefulWidget {
  const FamilyHubScreen({super.key});

  @override
  State<FamilyHubScreen> createState() => _FamilyHubScreenState();
}

class _FamilyHubScreenState extends State<FamilyHubScreen> {
  bool _isSelectionMode = false;
  Set<String> _selectedGroups = {};

  @override
  void dispose() {
    // Clear callback to prevent memory leaks
    TwilioService.clearCallCompletedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode 
            ? Text('${_selectedGroups.length} selected')
            : const Text('Family Hub'),
        centerTitle: true,
        actions: _isSelectionMode 
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _selectedGroups.isNotEmpty ? _deleteSelectedGroups : null,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _exitSelectionMode,
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () => _enterSelectionMode(),
                ),
              ],
      ),
      body: Consumer<FamilyProvider>(
        builder: (context, familyProvider, child) {
          if (!familyProvider.hasGroups) {
            return _buildEmptyState();
          }

          return _buildGroupsList(familyProvider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: AppConstants.primaryTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 80,
            color: AppConstants.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            'No Family Groups Yet',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Create your first family group to start\nsharing receipts with your loved ones',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXL),
          ElevatedButton.icon(
            onPressed: () => _showCreateGroupDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Group'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
                vertical: AppConstants.spacingM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList(FamilyProvider familyProvider) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppConstants.spacingM,
          mainAxisSpacing: AppConstants.spacingM,
          childAspectRatio: 1.2,
        ),
        itemCount: familyProvider.familyGroups.length,
        itemBuilder: (context, index) {
          final group = familyProvider.familyGroups[index];
          return _buildGroupCard(group, _selectedGroups.contains(group.id));
        },
      ),
    );
  }

  Widget _buildGroupCard(FamilyGroup group, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (_isSelectionMode) {
          _toggleGroupSelection(group.id);
        } else {
          _showGroupDetailsDialog(context, group);
        }
      },
      onLongPress: () {
        if (!_isSelectionMode) {
          _enterSelectionMode();
          _toggleGroupSelection(group.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
              ? AppConstants.primaryTeal.withOpacity(0.2)
              : AppConstants.surfaceDark,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isSelected 
                ? AppConstants.primaryTeal
                : AppConstants.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
                  child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group icon and name
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingS),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                          ),
                          child: Icon(
                            Icons.family_restroom,
                            color: AppConstants.primaryTeal,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Expanded(
                          child: Text(
                            '${group.name} Receipts',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeM,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Shared receipts count
                    if (group.hasSharedReceipts) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.receipt,
                            size: 16,
                            color: AppConstants.textSecondary,
                          ),
                          const SizedBox(width: AppConstants.spacingXS),
                          Text(
                            '${group.sharedReceiptIds.length} Receipts',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeS,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingXS),
                    ],
                    // Created date
                    Text(
                      'Created ${AppHelpers.timeAgo(group.createdAt)}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Selection checkbox (top-left when in selection mode)
              if (_isSelectionMode)
                Positioned(
                  top: AppConstants.spacingS,
                  left: AppConstants.spacingS,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppConstants.primaryTeal : AppConstants.textSecondary,
                      size: 24,
                    ),
                  ),
                ),
              // Member count badge (bottom-right)
              Positioned(
                bottom: AppConstants.spacingS,
                right: AppConstants.spacingS,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                    vertical: AppConstants.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryTeal,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  ),
                  child: Text(
                    '${group.memberCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeS,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceDark,
          title: Text(
            'Create Group',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(
              hintText: 'Enter group name',
              hintStyle: TextStyle(color: AppConstants.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                borderSide: BorderSide(color: AppConstants.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                borderSide: BorderSide(color: AppConstants.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                borderSide: BorderSide(color: AppConstants.primaryTeal),
              ),
            ),
            style: TextStyle(color: AppConstants.textPrimary),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final groupName = groupNameController.text.trim();
                if (groupName.isNotEmpty) {
                  context.read<FamilyProvider>().createGroup(groupName);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Group "$groupName" created successfully!'),
                      backgroundColor: AppConstants.primaryTeal,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showGroupDetailsDialog(BuildContext context, FamilyGroup group) {
    context.read<FamilyProvider>().selectGroup(group);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppConstants.surfaceDark,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryTeal.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusM),
                      topRight: Radius.circular(AppConstants.radiusM),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        color: AppConstants.primaryTeal,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Expanded(
                        child: Text(
                          group.name,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeL,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shared receipts section
                        Text(
                          'Shared Receipts',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        Expanded(
                          child: _buildSharedReceiptsList(group),
                        ),
                      ],
                    ),
                  ),
                ),
                // Action buttons
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundDark,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.radiusM),
                      bottomRight: Radius.circular(AppConstants.radiusM),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddReceiptsDialog(context, group),
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Add Receipts'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.primaryTeal,
                            side: BorderSide(color: AppConstants.primaryTeal),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showMembersDialog(context, group),
                          icon: const Icon(Icons.people),
                          label: const Text('Members'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.primaryTeal,
                            side: BorderSide(color: AppConstants.primaryTeal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Clear selected group when dialog closes
      context.read<FamilyProvider>().clearSelectedGroup();
    });
  }

  Widget _buildSharedReceiptsList(FamilyGroup group) {
    if (!group.hasSharedReceipts) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 48,
              color: AppConstants.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'No shared receipts yet',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Add receipts to share with group members',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: AppConstants.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // Show actual shared receipts with delete option
    final allReceipts = MockDataService.getSampleReceipts();
    final sharedReceipts = allReceipts.where((receipt) => 
        group.sharedReceiptIds.contains(receipt.id.toString())).toList();

    return ListView.builder(
      itemCount: sharedReceipts.length,
      itemBuilder: (context, index) {
        final receipt = sharedReceipts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
          padding: const EdgeInsets.all(AppConstants.spacingM),
          decoration: BoxDecoration(
            color: AppConstants.backgroundDark,
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
            border: Border.all(color: AppConstants.dividerColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.receipt,
                color: AppConstants.primaryTeal,
                size: 20,
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.merchantName,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeM,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    Text(
                      receipt.category,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    Text(
                      'Added ${AppHelpers.timeAgo(receipt.date)}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: AppConstants.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${receipt.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeM,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryTeal,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              IconButton(
                onPressed: () => _initiateExpenseCall(context, group, receipt),
                icon: Icon(
                  Icons.phone,
                  color: AppConstants.primaryTeal,
                  size: 20,
                ),
                tooltip: 'Call to split expense',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddReceiptsDialog(BuildContext context, FamilyGroup group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ReceiptSelectionDialog(group: group);
      },
    );
  }

  void _showMembersDialog(BuildContext context, FamilyGroup group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MembersManagementDialog(group: group);
      },
    );
  }

  void _showMembersDialogOld(BuildContext context, FamilyGroup group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppConstants.surfaceDark,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryTeal.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusM),
                      topRight: Radius.circular(AppConstants.radiusM),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: AppConstants.primaryTeal,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Group Members',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeL,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Members list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    itemCount: group.members.length,
                    itemBuilder: (context, index) {
                      final member = group.members[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
                        padding: const EdgeInsets.all(AppConstants.spacingM),
                        decoration: BoxDecoration(
                          color: AppConstants.backgroundDark,
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                          border: Border.all(color: AppConstants.dividerColor),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppConstants.primaryTeal.withOpacity(0.1),
                              child: Text(
                                member.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: AppConstants.primaryTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        member.name,
                                        style: TextStyle(
                                          fontSize: AppConstants.fontSizeM,
                                          fontWeight: FontWeight.w500,
                                          color: AppConstants.textPrimary,
                                        ),
                                      ),
                                      if (member.isAdmin) ...[
                                        const SizedBox(width: AppConstants.spacingS),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppConstants.spacingS,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppConstants.primaryTeal.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                                          ),
                                          child: Text(
                                            'Admin',
                                            style: TextStyle(
                                              fontSize: AppConstants.fontSizeS,
                                              color: AppConstants.primaryTeal,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    member.email,
                                    style: TextStyle(
                                      fontSize: AppConstants.fontSizeS,
                                      color: AppConstants.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    'Joined ${AppHelpers.timeAgo(member.joinedAt)}',
                                    style: TextStyle(
                                      fontSize: AppConstants.fontSizeS,
                                      color: AppConstants.textSecondary.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Add member button
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundDark,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.radiusM),
                      bottomRight: Radius.circular(AppConstants.radiusM),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddMemberDialog(context, group),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add Member'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryTeal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context, FamilyGroup group) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceDark,
          title: Text(
            'Add Member',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppConstants.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                ),
                style: TextStyle(color: AppConstants.textPrimary),
              ),
              const SizedBox(height: AppConstants.spacingM),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppConstants.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                ),
                style: TextStyle(color: AppConstants.textPrimary),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                if (name.isNotEmpty && email.isNotEmpty) {
                  context.read<FamilyProvider>().addMemberToGroup(
                    group.id,
                    name,
                    email,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name added to group successfully!'),
                      backgroundColor: AppConstants.primaryTeal,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
               );
     },
   );
 }

  
  // Initiate expense call using Twilio
  void _initiateExpenseCall(BuildContext context, FamilyGroup group, Receipt receipt) async {
    try {
      // Test Twilio connection first
      debugPrint('🔍 Testing Twilio connection...');
      final connectionOk = await TwilioService.testTwilioConnection();
      
      if (!connectionOk) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('❌ Twilio connection failed. Please check credentials.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // Set up callback for when call completes
      TwilioService.setCallCompletedCallback((pass, groupName) {
        debugPrint('🎊 UI Callback received! Showing popup for pass: ${pass.id}');
        
        // Check if the widget is still mounted before proceeding
        if (!context.mounted) {
          debugPrint('❌ Widget not mounted - cannot show popup');
          return;
        }
        
        try {
          // Close any open popups safely
          Navigator.of(context).popUntil((route) => route.isFirst);
          
          // Add the pass to the provider
          context.read<FamilyProvider>().addExpensePass(pass);
          debugPrint('✅ Added expense pass to provider');
          
          // Show success popup
          debugPrint('🎉 Showing ExpensePassPopup now!');
          ExpensePassPopup.show(
            context,
            pass: pass,
            groupName: groupName,
            onViewDetails: () {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Expense pass details will be available soon!'),
                  backgroundColor: AppConstants.primaryTeal,
                ),
              );
            },
          );
        } catch (e) {
          debugPrint('❌ Error in call completion callback: $e');
        }
      });

      // Show call progress popup
      CallProgressPopup.show(
        context,
        merchantName: receipt.merchantName,
        groupName: group.name,
        onCancel: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Call cancelled'),
              backgroundColor: AppConstants.textSecondary,
            ),
          );
        },
      );

      // Make REAL call to user's phone number
      final result = await TwilioService.initiateExpenseCall(
        userPhoneNumber: '+917094584185', // Your real phone number
        group: group,
        merchantName: receipt.merchantName,
        totalAmount: receipt.amount,
      );

      // Close the call progress popup
      Navigator.of(context).pop();

      if (result['success']) {
        final pass = result['pass'];
        
        // Add the pass to the provider
        context.read<FamilyProvider>().addExpensePass(pass);
        
        // Show success popup
        ExpensePassPopup.show(
          context,
          pass: pass,
          groupName: group.name,
          onViewDetails: () {
            // Navigate to expense pass details (you can implement this later)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Expense pass details will be available soon!'),
                backgroundColor: AppConstants.primaryTeal,
              ),
            );
          },
        );
        
        // Show conversation result in snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📞 ${result['conversation']}'),
            backgroundColor: AppConstants.primaryTeal,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Call failed: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close any open popups
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initiating call: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

 
  // Selection mode methods
  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedGroups.clear();
    });
  }

  void _toggleGroupSelection(String groupId) {
    setState(() {
      if (_selectedGroups.contains(groupId)) {
        _selectedGroups.remove(groupId);
      } else {
        _selectedGroups.add(groupId);
      }
    });

    // Exit selection mode if no groups are selected
    if (_selectedGroups.isEmpty) {
      _exitSelectionMode();
    }
  }

  void _deleteSelectedGroups() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceDark,
          title: Text(
            'Delete Groups',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${_selectedGroups.length} group(s)? This action cannot be undone.',
            style: TextStyle(color: AppConstants.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                for (String groupId in _selectedGroups) {
                  context.read<FamilyProvider>().deleteGroup(groupId);
                }
                Navigator.pop(context);
                _exitSelectionMode();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_selectedGroups.length} group(s) deleted successfully!'),
                    backgroundColor: AppConstants.primaryTeal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _ReceiptSelectionDialog extends StatefulWidget {
  final FamilyGroup group;

  const _ReceiptSelectionDialog({required this.group});

  @override
  State<_ReceiptSelectionDialog> createState() => _ReceiptSelectionDialogState();
}

class _ReceiptSelectionDialogState extends State<_ReceiptSelectionDialog> {
  Set<String> _selectedReceipts = {};
  List<Receipt> _availableReceipts = [];

  @override
  void initState() {
    super.initState();
    _availableReceipts = MockDataService.getSampleReceipts()
        .where((receipt) => !widget.group.sharedReceiptIds.contains(receipt.id.toString()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppConstants.surfaceDark,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.primaryTeal.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusM),
                  topRight: Radius.circular(AppConstants.radiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: AppConstants.primaryTeal,
                    size: 24,
                  ),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      'Add Receipts to ${widget.group.name}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Selected count
            if (_selectedReceipts.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.spacingS),
                color: AppConstants.primaryTeal.withOpacity(0.1),
                child: Text(
                  '${_selectedReceipts.length} receipt(s) selected',
                  style: TextStyle(
                    color: AppConstants.primaryTeal,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // Receipts list
            Expanded(
              child: _availableReceipts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 48,
                            color: AppConstants.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: AppConstants.spacingM),
                          Text(
                            'No receipts available',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeM,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          Text(
                            'All receipts are already shared',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeS,
                              color: AppConstants.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.spacingM),
                      itemCount: _availableReceipts.length,
                      itemBuilder: (context, index) {
                        final receipt = _availableReceipts[index];
                        final isSelected = _selectedReceipts.contains(receipt.id.toString());
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppConstants.primaryTeal.withOpacity(0.1)
                                : AppConstants.backgroundDark,
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            border: Border.all(
                              color: isSelected 
                                  ? AppConstants.primaryTeal
                                  : AppConstants.dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(AppConstants.spacingS),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryTeal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                              ),
                              child: Icon(
                                Icons.receipt,
                                color: AppConstants.primaryTeal,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              receipt.merchantName,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeM,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receipt.category,
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeS,
                                    color: AppConstants.textSecondary,
                                  ),
                                ),
                                Text(
                                  AppHelpers.timeAgo(receipt.date),
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeS,
                                    color: AppConstants.textSecondary.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${receipt.amount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeM,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.primaryTeal,
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacingS),
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? AppConstants.primaryTeal : AppConstants.textSecondary,
                                ),
                              ],
                            ),
                            onTap: () => _toggleReceiptSelection(receipt.id.toString()),
                          ),
                        );
                      },
                    ),
            ),
            // Action buttons
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.backgroundDark,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radiusM),
                  bottomRight: Radius.circular(AppConstants.radiusM),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.textSecondary,
                        side: BorderSide(color: AppConstants.textSecondary),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedReceipts.isNotEmpty ? _addSelectedReceipts : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryTeal,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Add (${_selectedReceipts.length})'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleReceiptSelection(String receiptId) {
    setState(() {
      if (_selectedReceipts.contains(receiptId)) {
        _selectedReceipts.remove(receiptId);
      } else {
        _selectedReceipts.add(receiptId);
      }
    });
  }

  void _addSelectedReceipts() {
    for (String receiptId in _selectedReceipts) {
      context.read<FamilyProvider>().addReceiptToGroup(widget.group.id, receiptId);
    }
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedReceipts.length} receipt(s) added to ${widget.group.name}!'),
        backgroundColor: AppConstants.primaryTeal,
      ),
    );
  }
}

class _MembersManagementDialog extends StatefulWidget {
  final FamilyGroup group;

  const _MembersManagementDialog({required this.group});

  @override
  State<_MembersManagementDialog> createState() => _MembersManagementDialogState();
}

class _MembersManagementDialogState extends State<_MembersManagementDialog> {
  bool _isSelectionMode = false;
  Set<String> _selectedMembers = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppConstants.surfaceDark,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with selection controls
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.primaryTeal.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusM),
                  topRight: Radius.circular(AppConstants.radiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: AppConstants.primaryTeal,
                    size: 24,
                  ),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      _isSelectionMode 
                          ? '${_selectedMembers.length} selected'
                          : 'Group Members',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                  ),
                  if (_isSelectionMode) ...[
                    if (_selectedMembers.isNotEmpty)
                      IconButton(
                        onPressed: _deleteSelectedMembers,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete selected members',
                      ),
                    IconButton(
                      onPressed: _exitMemberSelectionMode,
                      icon: Icon(Icons.close, color: AppConstants.textSecondary),
                      tooltip: 'Cancel selection',
                    ),
                  ] else ...[
                    IconButton(
                      onPressed: _enterMemberSelectionMode,
                      icon: Icon(Icons.select_all, color: AppConstants.textSecondary),
                      tooltip: 'Select members',
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: AppConstants.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            // Members list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                itemCount: widget.group.members.length,
                itemBuilder: (context, index) {
                  final member = widget.group.members[index];
                  final isSelected = _selectedMembers.contains(member.id);
                  final canDelete = !member.isAdmin;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppConstants.primaryTeal.withOpacity(0.1)
                          : AppConstants.backgroundDark,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      border: Border.all(
                        color: isSelected 
                            ? AppConstants.primaryTeal
                            : AppConstants.dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppConstants.primaryTeal.withOpacity(0.1),
                            child: Text(
                              member.name[0].toUpperCase(),
                              style: TextStyle(
                                color: AppConstants.primaryTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_isSelectionMode && canDelete)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? AppConstants.primaryTeal : AppConstants.textSecondary,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Text(
                            member.name,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeM,
                              fontWeight: FontWeight.w500,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          if (member.isAdmin) ...[
                            const SizedBox(width: AppConstants.spacingS),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingS,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryTeal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                              ),
                              child: Text(
                                'Admin',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeS,
                                  color: AppConstants.primaryTeal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.email,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeS,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                          Text(
                            'Joined ${AppHelpers.timeAgo(member.joinedAt)}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeS,
                              color: AppConstants.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (_isSelectionMode && canDelete) {
                          _toggleMemberSelection(member.id);
                        }
                      },
                      onLongPress: () {
                        if (!_isSelectionMode && canDelete) {
                          _enterMemberSelectionMode();
                          _toggleMemberSelection(member.id);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            // Add member button
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.backgroundDark,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radiusM),
                  bottomRight: Radius.circular(AppConstants.radiusM),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSelectionMode ? null : () => showAddMemberDialog(context),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Member'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryTeal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enterMemberSelectionMode() {
    setState(() {
      _isSelectionMode = true;
    });
  }

  void _exitMemberSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedMembers.clear();
    });
  }

  void _toggleMemberSelection(String memberId) {
    setState(() {
      if (_selectedMembers.contains(memberId)) {
        _selectedMembers.remove(memberId);
      } else {
        _selectedMembers.add(memberId);
      }
    });

    if (_selectedMembers.isEmpty) {
      _exitMemberSelectionMode();
    }
  }

  void _deleteSelectedMembers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceDark,
          title: Text(
            'Remove Members',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${_selectedMembers.length} member(s) from the group?',
            style: TextStyle(color: AppConstants.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppConstants.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _exitMemberSelectionMode();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_selectedMembers.length} member(s) removed!'),
                    backgroundColor: AppConstants.primaryTeal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceDark,
          title: Text('Add Member', style: TextStyle(color: AppConstants.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppConstants.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusS)),
                ),
                style: TextStyle(color: AppConstants.textPrimary),
              ),
              const SizedBox(height: AppConstants.spacingM),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppConstants.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusS)),
                ),
                style: TextStyle(color: AppConstants.textPrimary),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppConstants.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                if (name.isNotEmpty && email.isNotEmpty) {
                  context.read<FamilyProvider>().addMemberToGroup(widget.group.id, name, email);
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name added successfully!'),
                      backgroundColor: AppConstants.primaryTeal,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
} 