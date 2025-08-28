import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider responsável por gerenciar o modo de tema do app
/// Suporta: Sistema, Claro, Escuro
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'themeMode';

  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? _prefs;

  /// Modo de tema atual
  ThemeMode get themeMode => _themeMode;

  /// Compatibilidade com widgets existentes
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isSystem => _themeMode == ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  /// Carrega a preferência de tema salva
  void _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    // Migração: se preferências antigas existirem (bool 'isDarkMode'), converter
    if (_prefs!.containsKey('isDarkMode')) {
      final isDark = _prefs!.getBool('isDarkMode') ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      // Gravar no novo formato e limpar o antigo
      await _prefs!.setString(_themeKey, _themeMode.name);
      await _prefs!.remove('isDarkMode');
      notifyListeners();
      return;
    }

    final stored = _prefs?.getString(_themeKey);
    _themeMode = _stringToThemeMode(stored) ?? ThemeMode.system;
    notifyListeners();
  }

  /// Alterna entre claro e escuro (não usa "Sistema")
  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _saveTheme();
    notifyListeners();
  }

  /// Define o modo de tema explicitamente (Sistema/Claro/Escuro)
  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }

  /// Mantido por compatibilidade. Use setThemeMode no lugar.
  void setTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }

  /// Salva a preferência de tema
  Future<void> _saveTheme() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_themeKey, _themeMode.name);
  }

  ThemeMode? _stringToThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}
