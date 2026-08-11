import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF17152B);
  static const violet = Color(0xFF7257FF);
  static const coral = Color(0xFFFF6B7A);
  static const lemon = Color(0xFFFFD66B);
  static const mist = Color(0xFFF5F2FF);
  static const night = Color(0xFF11101C);
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: brightness,
      primary: isDark ? const Color(0xFFAFA0FF) : AppColors.violet,
      secondary: AppColors.coral,
      surface: isDark ? const Color(0xFF1D1B2A) : Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.night : AppColors.mist,
      textTheme: ThemeData(brightness: brightness).textTheme.copyWith(
            displaySmall: TextStyle(
              fontSize: 38,
              height: 1.08,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.4,
              color: isDark ? Colors.white : AppColors.ink,
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : AppColors.ink,
            ),
            titleLarge: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
            bodyLarge: TextStyle(
              height: 1.55,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.76)
                  : AppColors.ink.withValues(alpha: 0.72),
            ),
          ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF191724) : Colors.white.withValues(alpha: .96),
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
