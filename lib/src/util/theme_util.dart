import 'package:flutter/material.dart';

class ThemeUtil {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color getDividerColor(BuildContext context) =>
      Theme.of(context).dividerColor;

  static Color? getDarkColor(BuildContext context, Color darkColor) {
    return isDark(context) ? darkColor : null;
  }

  static Color getAccentColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color getPrimaryColor(BuildContext context) =>
      Theme.of(context).primaryColor;

  static Color? getBodyTextColor(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge?.color;

  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color getDialogBackgroundColor(BuildContext context) =>
      Theme.of(context).canvasColor;

  static Color getCardBackgroundColor(BuildContext context) =>
      Theme.of(context).cardColor;
}
