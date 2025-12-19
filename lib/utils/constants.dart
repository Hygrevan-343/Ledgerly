import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryTeal = Color(0xFF4DB6AC);
  static const Color primaryTealDark = Color(0xFF26A69A);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static const Color cardDark = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color dividerColor = Color(0xFF424242);
  
  // Category Colors
  static const Color categoryGroceries = Color(0xFF2196F3); // Blue
  static const Color categoryTransport = Color(0xFF4CAF50); // Green
  static const Color categoryDining = Color(0xFFFF9800); // Orange
  static const Color categoryOther = Color(0xFFF44336); // Red
  static const Color categoryShopping = Color(0xFF9C27B0); // Purple
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  
  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeTitle = 32.0;
  
  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  
  // App Bar Height
  static const double appBarHeight = 56.0;
  
  // Bottom Navigation Height
  static const double bottomNavHeight = 80.0;
  
  // FAB Size
  static const double fabSize = 56.0;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.primaryTeal,
        secondary: AppConstants.primaryTealDark,
        surface: AppConstants.surfaceDark,
        background: AppConstants.backgroundDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppConstants.textPrimary,
        onBackground: AppConstants.textPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppConstants.backgroundDark,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.backgroundDark,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: AppConstants.cardDark,
        elevation: AppConstants.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeL,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: AppConstants.fontSizeM,
        ),
        bodySmall: TextStyle(
          color: AppConstants.textSecondary,
          fontSize: AppConstants.fontSizeS,
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppConstants.primaryTeal,
        unselectedItemColor: AppConstants.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: AppConstants.elevationL,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryTeal,
        foregroundColor: Colors.white,
        elevation: AppConstants.elevationL,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryTeal,
          foregroundColor: Colors.white,
          elevation: AppConstants.elevationM,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: AppConstants.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: AppConstants.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: AppConstants.primaryTeal),
        ),
        hintStyle: const TextStyle(color: AppConstants.textSecondary),
        labelStyle: const TextStyle(color: AppConstants.textSecondary),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppConstants.dividerColor,
        thickness: 1,
      ),
    );
  }
} 