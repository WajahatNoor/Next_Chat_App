import 'package:flutter/material.dart';
import 'package:next_chat/app/res/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textColor,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
  );
}
