import 'package:flutter/material.dart';

class AppTheme {
  // ======= TOKENS =======
  static const _lightPrimary = Color(0xFF16A34A);
  static const _darkPrimary  = Color(0xFF22C55E);

  // =================
  // THEME: LIGHT MODE
  // =================
  static final lightTheme = _buildTheme(
    brightness: Brightness.light,
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: Colors.white,
      secondary: Color(0xFF6366F1), // indigo p/ chips/abas
      onSecondary: Colors.white,
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0F172A),
      background: Color(0xFFF8FAFC),
      onBackground: Color(0xFF0F172A),
      surfaceVariant: Color(0xFFE2E8F0),
      onSurfaceVariant: Color(0xFF475569),
      error: Color(0xFFEF4444),
      onError: Colors.white,
      outline: Color(0xFF94A3B8),
    ),
  );

  // ================
  // THEME: DARK MODE
  // ================
  static final darkTheme = _buildTheme(
    brightness: Brightness.dark,
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: Color(0xFF0A1F12),
      secondary: Color(0xFF818CF8),
      onSecondary: Color(0xFF0B0F14),
      surface: Color(0xFF111827),
      onSurface: Color(0xFFF1F5F9),
      background: Color(0xFF0B0F14),
      onBackground: Color(0xFFE5E7EB),
      surfaceVariant: Color(0xFF1F2937),
      onSurfaceVariant: Color(0xFFCBD5E1),
      error: Color(0xFFF87171),
      onError: Color(0xFF0B0F14),
      outline: Color(0xFF64748B),
    ),
  );

  // ======= BUILDER =======
  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme scheme,
  }) {
    final cs = scheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      primaryColor: cs.primary,
      scaffoldBackgroundColor: cs.background,

      // Tipografia
      textTheme: _textTheme(cs),

      // Cartões
      cardTheme: CardThemeData(
        elevation: brightness == Brightness.dark ? 4 : 2,
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        titleTextStyle: _textTheme(cs).titleLarge,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceVariant,
        hintStyle: TextStyle(color: cs.onSurfaceVariant.withOpacity(0.7)),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme cs) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: cs.primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: cs.primary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: cs.onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: cs.onBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: cs.onSurfaceVariant,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: cs.onSurfaceVariant,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: cs.outline, // legendas/auxiliares
      ),
    );
  }
}
