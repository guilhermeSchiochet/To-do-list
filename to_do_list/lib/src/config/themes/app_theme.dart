import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';

/// Temas claro e escuro do app.
/// Light and dark themes of the app.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light, AppColors.light);

  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);

  /// Monta o [ThemeData] a partir de um conjunto de cores, evitando duplicar
  /// a configuração entre os dois temas.
  static ThemeData _build(Brightness brightness, AppColors colors) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.surface,
      dividerColor: colors.separator,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      primaryColor: AppPalette.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppPalette.primary,
        brightness: brightness,
        primary: AppPalette.primary,
        surface: colors.surface,
        error: AppPalette.red,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppPalette.primary),
        titleTextStyle: TextStyle(
          color: colors.label,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppPalette.primary,
        selectionHandleColor: AppPalette.primary,
      ),
      dividerTheme: DividerThemeData(
        color: colors.separator,
        space: 1,
        thickness: 0.5,
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surface),
      datePickerTheme: DatePickerThemeData(backgroundColor: colors.surface),
      timePickerTheme: TimePickerThemeData(backgroundColor: colors.surface),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? colors.fill : const Color(0xFF323232),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      extensions: [colors],
    );
  }
}
