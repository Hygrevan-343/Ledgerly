import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _userName;
  String? _userProfilePic;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userProfilePic => _userProfilePic;

  // Placeholder credentials
  static const String _validEmail = 'kavinesh.p123@gmail.com';
  static const String _validPassword = 'test123';
  static const String _defaultProfilePic = 'https://avatar.iran.liara.run/public/43';
  static const String _defaultUserName = 'Admin User';

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == _validEmail && password == _validPassword) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = _defaultUserName;
      _userProfilePic = _defaultProfilePic;
      
      // Save login state to SharedPreferences (will be cleared on app restart)
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userName', _defaultUserName);
        await prefs.setString('userProfilePic', _defaultProfilePic);
        print('✅ User logged in successfully');
      } catch (e) {
        print('Error saving login state: $e');
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    _userProfilePic = null;
    
    // Clear login state from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userEmail');
      await prefs.remove('userName');
      await prefs.remove('userProfilePic');
      print('🔓 User logged out - returning to login screen');
    } catch (e) {
      print('Error clearing login state: $e');
    }
    
    notifyListeners();
  }

  // Check if user is already logged in (for app startup)
  // Check cached login state and restore if valid
  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if user was previously logged in
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      if (isLoggedIn) {
        // Restore user data from cache
        _isLoggedIn = true;
        _userEmail = prefs.getString('userEmail') ?? _validEmail;
        _userName = prefs.getString('userName') ?? _defaultUserName;
        _userProfilePic = prefs.getString('userProfilePic') ?? _defaultProfilePic;
        
        print('✅ Login restored from cache for ${_userEmail}');
      } else {
        // No cached login, start fresh
        _isLoggedIn = false;
        _userEmail = null;
        _userName = null;
        _userProfilePic = null;
        
        print('🔄 No cached login found - starting from login page');
      }
      
      notifyListeners();
    } catch (e) {
      print('Error checking auth status: $e');
      _isLoggedIn = false;
      notifyListeners();
    }
  }
} 