import 'package:flutter/material.dart';
import 'package:map_test/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppTheme.normalTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleHighContrast() {
    _currentTheme = _currentTheme == AppTheme.normalTheme
        ? AppTheme.highContrastTheme
        : AppTheme.normalTheme;
    notifyListeners();
  }
}
