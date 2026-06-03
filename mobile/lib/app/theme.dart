import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const backgroundPrimary = Color(0xFF060816);
  static const backgroundSecondary = Color(0xFF0B1020);
  static const surfacePrimary = Color(0xFF141D33);
  static const surfaceSecondary = Color(0xFF18243D);
  static const primaryAccent = Color(0xFF7C5CFF);
  static const secondaryAccent = Color(0xFF4DA8FF);
  static const success = Color(0xFF6EE7B7);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFFF6B7A);
  static const textPrimary = Color(0xFFF5F7FF);
  static const textSecondary = Color(0xFFB7C1D9);
  static const textMuted = Color(0xFF7D8AA8);
  static const glassSurface = Color(0x0FFFFFFF);
  static const border = Color(0x1AFFFFFF);
}

class AppGradients {
  const AppGradients._();

  static const primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryAccent,
      AppColors.secondaryAccent,
    ],
  );

  static const aiSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x337C5CFF),
      Color(0x264DA8FF),
    ],
  );

  static const backgroundGlow = RadialGradient(
    center: Alignment(-0.8, -0.9),
    radius: 1.1,
    colors: [
      Color(0x2A7C5CFF),
      AppColors.backgroundPrimary,
    ],
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => darkTheme;

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryAccent,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.secondaryAccent,
      onSecondary: AppColors.backgroundPrimary,
      error: AppColors.danger,
      onError: AppColors.textPrimary,
      surface: AppColors.backgroundSecondary,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      shadow: Colors.black,
    );

    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
    );
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: AppColors.surfacePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: AppColors.surfacePrimary,
        indicatorColor: AppColors.primaryAccent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);

          return TextStyle(
            color: selected ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);

          return IconThemeData(
            color: selected ? AppColors.textPrimary : AppColors.textMuted,
            size: 22,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: AppColors.glassSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
