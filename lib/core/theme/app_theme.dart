import 'package:flutter/material.dart';

class AppTheme {
  // =================
  // THEME: LIGHT MODE
  // =================
  static final lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xFF16A34A), // Primary (brand/CTAs)
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF16A34A),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Background
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF16A34A), // titles usando a primária
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF16A34A),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A), // onBackground
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF475569), // onSurfaceVariant
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF475569),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFF94A3B8),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: Colors.white, // Surface
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF16A34A), // primary
        foregroundColor: Colors.white,            // onPrimary
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  // ================
  // THEME: DARK MODE
  // ================
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF22C55E),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF22C55E),
      brightness: Brightness.dark,
      primary: const Color(0xFF22C55E),
      onPrimary: const Color(0xFF0A1F12),
      secondary: const Color(0xFF818CF8),         // indigo claro p/ abas/chips
      onSecondary: const Color(0xFF0B0F14),
      surface: const Color(0xFF111827),
      onSurface: const Color(0xFFF1F5F9),
      background: const Color(0xFF0B0F14),
      onBackground: const Color(0xFFE5E7EB),
      surfaceVariant: const Color(0xFF1F2937),
      onSurfaceVariant: const Color(0xFFCBD5E1),
      error: Color(0xFFF87171),
    ),
    scaffoldBackgroundColor: const Color(0xFF0B0F14),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF22C55E), // títulos com a primária no dark
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF22C55E),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE5E7EB), // onBackground
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFFE5E7EB),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFFCBD5E1), // onSurfaceVariant
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFFCBD5E1),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFF94A3B8),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: const Color(0xFF111827), // Surface
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: const Color(0xFF0A1F12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111827),
      foregroundColor: Color(0xFFE5E7EB),
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF1F2937), // surfaceVariant
      hintStyle: TextStyle(color: Color(0xFF94A3B8)),
    ),
  );
}
