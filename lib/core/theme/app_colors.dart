import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Green Palette
  static const Color primaryGreen = Color(0xFF2ECC71);
  static const Color primaryDark = Color(0xFF27AE60);
  static const Color primaryLight = Color(0xFF82E0AA);
  static const Color primarySurface = Color(0xFFE8F8F0);

  // Accent
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentBlue = Color(0xFF3498DB);
  static const Color accentPurple = Color(0xFF9B59B6);
  static const Color accentRed = Color(0xFFE74C3C);

  // Neutrals - Light
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color dividerLight = Color(0xFFE5E7EB);

  // Neutrals - Dark
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF1C2333);
  static const Color textPrimaryDark = Color(0xFFF0F6FC);
  static const Color textSecondaryDark = Color(0xFF8B949E);
  static const Color dividerDark = Color(0xFF30363D);

  // Chart Colors
  static const Color chartGreen = Color(0xFF2ECC71);
  static const Color chartBlue = Color(0xFF3498DB);
  static const Color chartOrange = Color(0xFFFF6B35);
  static const Color chartPurple = Color(0xFF9B59B6);
  static const Color chartRed = Color(0xFFE74C3C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient calorieGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFE74C3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF4B9EF3), Color(0xFF3498DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Activity Specific Colors
  static const Color activityBlue = Color(0xFF4B9EF3);
  static const Color activityLightBlue = Color(0xFFE3F2FD);
  static const Color activityOrange = Color(0xFFF39C12);
  static const Color activityGrey = Color(0xFF9EA3A0);
}
