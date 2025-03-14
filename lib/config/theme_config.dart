import 'package:flutter/material.dart';

/// Configuration class for app theme settings
class ThemeConfig {
  /// Default seed color for the app theme
  static const Color defaultSeedColor = Colors.blue;

  /// Key for storing theme mode preference
  static const String themeModeKey = 'theme_mode';

  /// Key for storing seed color preference
  static const String seedColorKey = 'seed_color';

  /// Key for storing if dynamic color is enabled
  static const String useDynamicColorsKey = 'use_dynamic_colors';

  /// Default border radius for widgets
  static const double defaultBorderRadius = 12.0;

  /// Default padding for content
  static const double defaultPadding = 16.0;

  /// Default text theme parameters
  static const String defaultFontFamily = 'Roboto';

  /// Default elevation for cards and surfaces
  static const double defaultElevation = 1.0;

  /// Default theme mode (system, light, dark)
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  /// Default setting for using system's dynamic colors (Material You)
  static const bool defaultUseDynamicColors = true;

  /// Generate shadow colors for different elevations
  static List<BoxShadow> getShadowsForElevation(double elevation) {
    if (elevation <= 0) return [];

    final opacity = 0.1 + (elevation * 0.02);
    final spreadRadius = elevation * 0.1;
    final blurRadius = elevation * 2;
    final offset = Offset(0, elevation * 0.5);

    return [
      BoxShadow(
        color: Colors.black.withOpacity(opacity),
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }
}
