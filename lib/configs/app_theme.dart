import "package:flutter/material.dart";
import "package:ricemoto/values/app_colors.dart";

/// Light theme for Rice Moto.
class AppTheme {
  const AppTheme._();

  static const EdgeInsets _buttonPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(padding: _buttonPadding),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(padding: _buttonPadding),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(padding: _buttonPadding),
    ),
    fontFamily: "Roboto",
  );
}
