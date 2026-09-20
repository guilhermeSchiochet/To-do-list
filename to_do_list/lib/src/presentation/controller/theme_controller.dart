import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/data/services/preferences_service.dart';

/// Mantém o tema escolhido e o grava nas preferências.
/// Keeps the chosen theme and writes it to the preferences.
class ThemeController {
  final PreferencesService _preferences;

  ThemeController({PreferencesService? preferencesService})
      : _preferences = preferencesService ?? PreferencesService();

  final ValueNotifier<ThemeMode> _mode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ValueListenable<ThemeMode> get mode => _mode;

  /// Carrega o tema salvo antes da primeira construção da árvore.
  Future<void> load() async {
    _mode.value = await _preferences.loadThemeMode();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode.value == mode) return;
    _mode.value = mode;
    await _preferences.saveThemeMode(mode);
  }

  void dispose() => _mode.dispose();
}
