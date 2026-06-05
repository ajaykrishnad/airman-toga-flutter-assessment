import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Aviation Color Palette - High Contrast
  static const Color _navyPrimary = Color(0xFF0A1929);
  static const Color _navySecondary = Color(0xFF1A2942);
  static const Color _skyBlue = Color(0xFF2196F3);
  static const Color _skyBlueLight = Color(0xFF64B5F6);
  static const Color _slateGray = Color(0xFF455A64);
  static const Color _slateLight = Color(0xFF90A4AE);
  static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _warningAmber = Color(0xFFFFC107);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _alertOrange = Color(0xFFFF9800);
  static const Color _surfaceLight = Color(0xFFF5F7FA);
  static const Color _surfaceDark = Color(0xFF121E2E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _navyPrimary,
        onPrimary: Colors.white,
        primaryContainer: _skyBlueLight,
        onPrimaryContainer: _navyPrimary,
        secondary: _slateGray,
        onSecondary: Colors.white,
        secondaryContainer: _slateLight,
        onSecondaryContainer: _navyPrimary,
        tertiary: _skyBlue,
        onTertiary: Colors.white,
        error: _errorRed,
        onError: Colors.white,
        errorContainer: Color(0xFFFFCDD2),
        onErrorContainer: _errorRed,
        surface: _surfaceLight,
        onSurface: _navyPrimary,
        outline: _slateGray,
        outlineVariant: _slateLight,
        shadow: Colors.black26,
        scrim: Colors.black54,
        inverseSurface: _navyPrimary,
        onInverseSurface: Colors.white,
        inversePrimary: _skyBlue,
      ),
      scaffoldBackgroundColor: _surfaceLight,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: _navyPrimary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        color: Colors.white,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _slateLight.withValues(alpha: 0.3)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _navyPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _skyBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _navyPrimary,
          side: BorderSide(color: _navyPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _slateGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _slateLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _skyBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(color: _slateGray),
        hintStyle: TextStyle(color: _slateLight),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _skyBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _navyPrimary,
        unselectedItemColor: _slateGray,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: DividerThemeData(
        color: _slateLight.withValues(alpha: 0.5),
        thickness: 1,
      ),
      iconTheme: IconThemeData(
        color: _navyPrimary,
        size: 24,
      ),
      textTheme: _buildTextTheme(_navyPrimary),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _skyBlue,
        onPrimary: Colors.white,
        primaryContainer: _navySecondary,
        onPrimaryContainer: Colors.white,
        secondary: _slateLight,
        onSecondary: _navyPrimary,
        secondaryContainer: _slateGray,
        onSecondaryContainer: Colors.white,
        tertiary: _skyBlueLight,
        onTertiary: _navyPrimary,
        error: _errorRed,
        onError: Colors.white,
        errorContainer: Color(0xFFB71C1C),
        onErrorContainer: Colors.white,
        surface: _surfaceDark,
        onSurface: Colors.white,
        outline: _slateLight,
        outlineVariant: _slateGray,
        shadow: Colors.black45,
        scrim: Colors.black87,
        inverseSurface: Colors.white,
        onInverseSurface: _navyPrimary,
        inversePrimary: _navyPrimary,
      ),
      scaffoldBackgroundColor: _surfaceDark,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: _navySecondary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        color: _navySecondary,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _slateGray.withValues(alpha: 0.3)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _skyBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _skyBlueLight,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _skyBlue,
          side: BorderSide(color: _skyBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _navySecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _slateLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _slateGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _skyBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(color: _slateLight),
        hintStyle: TextStyle(color: _slateGray),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _skyBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _navySecondary,
        selectedItemColor: _skyBlue,
        unselectedItemColor: _slateLight,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: DividerThemeData(
        color: _slateGray.withValues(alpha: 0.5),
        thickness: 1,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      textTheme: _buildTextTheme(Colors.white),
    );
  }

  static TextTheme _buildTextTheme(Color primaryColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  }

  // Alert colors for aviation notifications
  static Color get successColor => _successGreen;
  static Color get warningColor => _warningAmber;
  static Color get errorColor => _errorRed;
  static Color get alertColor => _alertOrange;
  static Color get infoColor => _skyBlue;

  // Status colors for aircraft and flight status
  static Color get statusActive => _successGreen;
  static Color get statusInactive => _slateGray;
  static Color get statusMaintenance => _warningAmber;
  static Color get statusGrounded => _errorRed;
  static Color get statusInFlight => _skyBlue;
}
