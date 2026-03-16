import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isBlueTheme = false;
  bool get isBlueTheme => _isBlueTheme;

  void toggleTheme() {
    _isBlueTheme = !_isBlueTheme;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isBlueTheme ? _blueTheme : _lightTheme;
  }

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light, 
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: Colors.white,
  );

  final ThemeData _blueTheme = ThemeData(
    brightness: Brightness.dark, 
    
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: const Color(0xFF1E293B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F172A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF334155),
    
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}