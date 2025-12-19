import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/spending_chart.dart';
import '../widgets/progress_bar.dart';
import '../services/widget_service.dart';
import 'family_hub_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          onSelected: (String value) {
            // Handle menu selection
            switch (value) {
              case 'expense_analytics':
                Navigator.pushNamed(context, '/expense-analytics');
                break;
              case 'family_hub':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FamilyHubScreen()),
                );
                break;
              case 'add_widget':
                _requestAddWidget(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'expense_analytics',
              child: ListTile(
                leading: Icon(Icons.analytics_outlined, color: AppConstants.primaryTeal),
                title: Text('Expense Analytics'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'family_hub',
              child: ListTile(
                leading: Icon(Icons.family_restroom_outlined, color: AppConstants.primaryTeal),
                title: Text('Family Hub'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'add_widget',
              child: ListTile(
                leading: Icon(Icons.widgets_outlined, color: AppConstants.primaryTeal),
                title: Text('Add Widget'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                offset: const Offset(0, 50),
                child: Container(
                  margin: const EdgeInsets.only(right: AppConstants.spacingM),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: authProvider.userProfilePic != null
                        ? NetworkImage(authProvider.userProfilePic!)
                        : null,
                    backgroundColor: AppConstants.primaryTeal,
                    child: authProvider.userProfilePic == null
                        ? const Icon(Icons.person, color: Colors.white, size: 20)
                        : null,
                  ),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: authProvider.userProfilePic != null
                                  ? NetworkImage(authProvider.userProfilePic!)
                                  : null,
                              backgroundColor: AppConstants.primaryTeal,
                              child: authProvider.userProfilePic == null
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: AppConstants.spacingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authProvider.userName ?? 'User',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppConstants.fontSizeM,
                                      color: AppConstants.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    authProvider.userEmail ?? 'user@example.com',
                                    style: const TextStyle(
                                      fontSize: AppConstants.fontSizeS,
                                      color: AppConstants.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        const Divider(
                          color: AppConstants.dividerColor,
                          thickness: 1,
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'sign_out',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingS),
                      child: const Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onSelected: (String value) {
                  if (value == 'sign_out') {
                    _showSignOutDialog(context    );
  }
  
  void _requestAddWidget(BuildContext context) async {
    try {
      final isSupported = await WidgetService.isWidgetSupported();
      
      if (isSupported) {
        await WidgetService.requestPinWidget();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Widget is available! Add it from your home screen widget picker.'),
            backgroundColor: AppConstants.primaryTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Widgets are not supported on this device'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add widget'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
},
              );
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryTeal,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshData,
            color: AppConstants.primaryTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCard(provider),
                  const SizedBox(height: AppConstants.spacingL),
                  _buildRecentActivityCard(provider),
                                      const SizedBox(height: AppConstants.spacingL),
                    _buildQuickActions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(AppProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Row(
              children: [
                Text(
                  AppHelpers.formatCurrency(provider.currentMonthSpending),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                    vertical: AppConstants.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: provider.monthlyChange >= 0
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Text(
                    AppHelpers.formatPercentage(provider.monthlyChange),
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      fontWeight: FontWeight.w500,
                      color: provider.monthlyChange >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingXS),
            const Text(
              'This month',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            if (provider.chartData.isNotEmpty)
              SpendingChart(
                data: provider.chartData,
                height: 150,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(AppProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXS),
                      Text(
                        AppHelpers.formatCurrency(provider.todaySpending),
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeXL,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This Week',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXS),
                      Text(
                        AppHelpers.formatCurrency(provider.weekSpending),
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeXL,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingL),
            if (provider.categories.isNotEmpty)
              CategoryProgressBar(
                categories: provider.categories,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.camera_alt,
                    label: 'Scan Receipt',
                    onTap: () {
                      // TODO: Implement camera
                      //ScaffoldMessenger.of(context).showSnackBar(
                      //  const SnackBar(content: Text('Camera feature coming soon!')),
                      //);
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.analytics_outlined,
                    label: 'View Reports',
                    onTap: () {
                      // TODO: Implement reports
                      //ScaffoldMessenger.of(context).showSnackBar(
                      //  const SnackBar(content: Text('Reports feature coming soon!')),
                      //);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        decoration: BoxDecoration(
          color: AppConstants.surfaceDark,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: AppConstants.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppConstants.primaryTeal,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceDark,
          title: const Text(
            'Sign Out',
            style: TextStyle(color: AppConstants.textPrimary),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: AppConstants.textSecondary),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
  
  void _requestAddWidget(BuildContext context) async {
    try {
      final isSupported = await WidgetService.isWidgetSupported();
      
      if (isSupported) {
        await WidgetService.requestPinWidget();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Widget added to home screen!'),
            backgroundColor: AppConstants.primaryTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Widgets are not supported on this device'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add widget'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }


} 