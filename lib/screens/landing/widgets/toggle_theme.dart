import 'package:flutter/material.dart';
import 'package:map_test/theme/theme.dart';
import 'package:map_test/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ElevatedButton(
          onPressed: () {
            themeProvider
                .toggleHighContrast(); // Toggle between high contrast and normal themes
          },
          child: Icon(themeProvider.currentTheme == AppTheme.highContrastTheme
              ? Icons.light_mode
              : Icons.contrast),
        );
      },
    );
  }
}
