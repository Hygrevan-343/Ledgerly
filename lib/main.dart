import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:home_widget/home_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/constants.dart';
import 'screens/dashboard_screen.dart';
import 'screens/receipts_screen.dart';
import 'screens/family_hub_screen.dart';
import 'screens/assist_screen.dart';
import 'screens/expense_analytics_screen.dart';
import 'screens/login_screen.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/family_provider.dart';
import 'services/widget_service.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // COMPLETELY DISABLE ALL DEBUG FEATURES
  debugPrint = (String? message, {int? wrapWidth}) {};
  
  // Override all debug settings globally
  if (kDebugMode) {
    // Disable debug painting, overflow indicators, and debug banners
    debugPaintSizeEnabled = false;
    debugRepaintRainbowEnabled = false;
    debugDisableClipLayers = false;
    debugDisablePhysicalShapeLayers = false;
    debugDisableOpacityLayers = false;
  }
  
  // Initialize Firebase directly
  await FirebaseService.initialize();
  
  // Initialize widget service
  await WidgetService.initialize();
  
  // Set up widget interaction callback
  HomeWidget.widgetClicked.listen((Uri? uri) async {
    if (uri != null) {
      final action = uri.host;
      if (action != null) {
        await WidgetService.handleWidgetInteraction(action);
      }
    }
  });
  
  // Run the app with complete debug override
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
      ],
      child: MaterialApp(
        title: 'Raseed',
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/expense-analytics': (context) => const ExpenseAnalyticsScreen(),
          '/assist': (context) => const MainScreen(),
        },
        // COMPLETELY DISABLE ALL DEBUG FEATURES
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        showSemanticsDebugger: false,
        checkerboardRasterCacheImages: false,
        checkerboardOffscreenLayers: false,
        builder: (context, widget) {
          // Override error widget to prevent any debug displays
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return const SizedBox.shrink();
          };
          
          return widget!;
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status on app start
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AuthProvider>().checkAuthStatus();
      
      // Check for pending widget actions immediately and repeatedly
      await _handlePendingWidgetAction();
      
      // Set up periodic check for widget actions (in case of timing issues)
      _setupPeriodicWidgetCheck();
    });
  }
  
  void _setupPeriodicWidgetCheck() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      final action = await WidgetService.peekPendingAction();
      if (action != null && action.isNotEmpty) {
        timer.cancel();
        // Get and consume the action
        final actualAction = await WidgetService.getPendingAction();
        if (actualAction != null) {
          await _handleWidgetAction(actualAction);
        }
      }
    });
  }
  
  Future<void> _handlePendingWidgetAction() async {
    final action = await WidgetService.getPendingAction();
    if (action != null && action.isNotEmpty && mounted) {
      await _handleWidgetAction(action);
    }
  }
  
  Future<void> _handleWidgetAction(String action) async {
    if (!mounted) return;
    
    final authProvider = context.read<AuthProvider>();
    
    if (authProvider.isLoggedIn) {
      // User is logged in, handle action immediately
      await _executePendingAction(action);
    } else {
      // User is not logged in, save action for after login
      await _savePendingActionForLogin(action);
    }
  }
  
  Future<void> _executePendingAction(String action) async {
    print('🎯 Executing widget action: $action');
    
    // Show immediate feedback to user
    _showInfoMessage('Widget action: $action');
    
    switch (action) {
      case 'camera':
        print('📸 Camera button was pressed');
        await _handleCameraAction();
        break;
      case 'gallery':
        print('🖼️ Gallery button was pressed');
        await _handleGalleryAction();
        break;
      case 'assist':
        print('💬 Assist button was pressed');
        await _navigateToAssist();
        break;
      case 'main':
      default:
        print('🏠 Main area was pressed');
        // Already opening main screen
        break;
    }
  }
  
  Future<void> _savePendingActionForLogin(String action) async {
    try {
      await WidgetService.saveActionForLogin(action);
    } catch (e) {
      print('Error saving action for login: $e');
    }
  }
  
  Future<void> _handleCameraAction() async {
    try {
      print('📸 Starting camera action...');
      // Ensure we're on the main screen
      await _ensureMainScreen();
      
      if (mounted) {
        print('📸 Opening camera...');
        final picker = ImagePicker();
        final image = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
        );
        if (image != null) {
          // Process the image or navigate to receipts screen
          print('📸 Photo captured: ${image.path}');
          _showSuccessMessage('Photo captured! Processing receipt...');
          // TODO: Add actual receipt processing logic here
        } else {
          print('📸 Camera cancelled');
          _showInfoMessage('Camera cancelled');
        }
      }
    } catch (e) {
      print('📸 Camera error: $e');
      _showErrorMessage('Failed to open camera: $e');
    }
  }
  
  Future<void> _handleGalleryAction() async {
    try {
      print('🖼️ Starting gallery action...');
      // Ensure we're on the main screen
      await _ensureMainScreen();
      
      if (mounted) {      
        print('🖼️ Opening gallery...');
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          // Process the image or navigate to receipts screen
          print('🖼️ Image selected: ${image.path}');
          _showSuccessMessage('Image selected! Processing receipt...');
          // TODO: Add actual receipt processing logic here
        } else {
          print('🖼️ Gallery cancelled');
          _showInfoMessage('Gallery cancelled');
        }
      }
    } catch (e) {
      print('🖼️ Gallery error: $e');
      _showErrorMessage('Failed to open gallery: $e');
    }
  }
  
  Future<void> _ensureMainScreen() async {
    // Navigate to main screen if not already there
    Navigator.pushReplacementNamed(context, '/main');
    // Wait for navigation to complete
    await Future.delayed(const Duration(milliseconds: 400));
  }
  
  Future<void> _navigateToAssist() async {
    try {
      print('💬 Starting assist navigation...');
      
      // Navigate to main screen first
      Navigator.pushReplacementNamed(context, '/main');
      
      // Wait for navigation and then directly trigger assist tab switch
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Find the current main screen and trigger assist tab
      if (mounted) {
        // Use a more direct approach to trigger assist navigation
        await WidgetService.saveActionForLogin('assist_direct');
        
        // Also save as regular action for immediate pickup
        await WidgetService.handleWidgetInteraction('assist');
      }
      
      print('💬 Navigate to assist completed');
    } catch (e) {
      print('💬 Navigate to assist error: $e');
      _showErrorMessage('Failed to open assist: $e');
    }
  }
  
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppConstants.primaryTeal,
        ),
      );
    }
  }
  
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showInfoMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoggedIn) {
          // User just logged in, check for pending actions
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final pendingAction = await WidgetService.getPendingLoginAction();
            if (pendingAction != null && pendingAction.isNotEmpty) {
              await _executePendingAction(pendingAction);
            }
          });
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<AssistScreenState> _assistScreenKey = GlobalKey<AssistScreenState>();

  late final List<Widget> _screens = [
    const DashboardScreen(),
    const ReceiptsScreen(),
    AssistScreen(key: _assistScreenKey),
  ];
  
  @override
  void initState() {
    super.initState();
    // Check if we need to switch to assist tab from widget
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkForAssistNavigation();
    });
  }
  
  Future<void> _checkForAssistNavigation() async {
    // Check for assist action specifically
    final assistAction = await WidgetService.getPendingLoginAction();
    if (assistAction == 'assist_ready' || assistAction == 'assist_direct') {
      print('💬 MainScreen: Switching to assist tab for action: $assistAction');
      setState(() {
        _currentIndex = 2; // Switch to assist tab (now index 2)
      });
      
      // Notify the assist screen to focus keyboard
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        // Trigger keyboard focus on the assist screen
        print('💬 MainScreen: Focusing keyboard on assist screen');
        _assistScreenKey.currentState?.focusKeyboard();
      }
    }
    
    // Also check for regular widget actions
    final action = await WidgetService.getPendingAction();
    if (action == 'assist') {
      print('💬 MainScreen: Switching to assist tab for widget action');
      setState(() {
        _currentIndex = 2; // Switch to assist tab (now index 2)
      });
      
      // Also focus keyboard for regular widget actions
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _assistScreenKey.currentState?.focusKeyboard();
      }
    }
  }

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.receipt_outlined),
      activeIcon: Icon(Icons.receipt),
      label: 'Receipts',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      activeIcon: Icon(Icons.chat),
      label: 'Assist',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppConstants.surfaceDark,
          border: Border(
            top: BorderSide(
              color: AppConstants.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: _navItems,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppConstants.primaryTeal,
          unselectedItemColor: AppConstants.textSecondary,
          selectedFontSize: AppConstants.fontSizeS,
          unselectedFontSize: AppConstants.fontSizeS,
          elevation: 0,
        ),
      ),
    );
  }
} 