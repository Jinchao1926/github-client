import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeColors {
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color secondaryBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? DarkColors.secondaryBackground
        : LightColors.secondaryBackground;
  }

  static Color tertiaryBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? DarkColors.tertiaryBackground
        : LightColors.tertiaryBackground;
  }

  /// Returns primary text color
  static Color primaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? DarkColors.primaryText : LightColors.primaryText;
  }

  static Color secondaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? DarkColors.secondaryText : LightColors.secondaryText;
  }

  static Color arrowColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? DarkColors.arrowColor : LightColors.arrowColor;
  }
}
