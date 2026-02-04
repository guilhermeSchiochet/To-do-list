import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  static final ThemeController _instance = ThemeController._internal();

  ThemeController._internal();

  factory ThemeController() => _instance;

  ThemeMode _theme = ThemeMode.system;

  ThemeMode get theme => _theme;

  void alterarTema(ThemeMode newTheme) {
    if (_theme == newTheme) return;
    _theme = newTheme;

    notifyListeners();
  }
}