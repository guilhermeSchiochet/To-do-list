import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';

/// Guarda as preferências do usuário entre execuções do app.
/// Stores the user's preferences across app runs.
class PreferencesService {
  static const String _themeModeKey = 'theme_mode';
  static const String _hiddenCategoriesKey = 'hidden_categories';

  /// Lê o tema salvo. Na primeira execução segue o tema do sistema.
  /// Reads the saved theme. On the first run it follows the system theme.
  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeModeKey);

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  /// Listas que o usuário escolheu esconder da tela Lists.
  /// Lists the user chose to hide from the Lists screen.
  Future<Set<TaskCategory>> loadHiddenCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_hiddenCategoriesKey) ?? const [];

    return saved.map(TaskCategory.fromStorage).toSet();
  }

  Future<void> saveHiddenCategories(Set<TaskCategory> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _hiddenCategoriesKey,
      categories.map((category) => category.name).toList(),
    );
  }
}
