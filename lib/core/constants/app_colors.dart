import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Light Blue palette (Spotify-inspired but blue)
  static const Color primary = Color(0xFF1DB8E8);
  static const Color primaryDark = Color(0xFF0A9DC7);
  static const Color primaryLight = Color(0xFF5DD0F5);
  static const Color primarySurface = Color(0xFF0D1B2A);

  // Background
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF1C2333);
  static const Color cardBg = Color(0xFF1F2937);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8C1);
  static const Color textMuted = Color(0xFF6B7280);

  // Status
  static const Color success = Color(0xFF1ED760);
  static const Color error = Color(0xFFE84040);
  static const Color warning = Color(0xFFFFA500);

  // Gradient stops
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1DB8E8), Color(0xFF0A6EBD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D1B2A), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient playerGradient = LinearGradient(
    colors: [Color(0xFF1A3A5C), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
