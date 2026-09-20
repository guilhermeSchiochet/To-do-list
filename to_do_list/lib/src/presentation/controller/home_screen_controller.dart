import 'package:flutter/foundation.dart';

/// Aba atualmente exibida na barra inferior.
/// The tab currently shown in the bottom bar.
///
/// O índice do enum é a posição do item na barra; [newTask] não é uma aba,
/// abre o editor de tarefas.
enum HomeTab { today, calendar, newTask, lists, settings }

/// Estado de navegação da tela principal.
/// Navigation state of the main screen.
class HomeScreenController {
  final ValueNotifier<HomeTab> _selectedTab =
      ValueNotifier<HomeTab>(HomeTab.today);

  ValueListenable<HomeTab> get selectedTab => _selectedTab;

  /// Muda de aba. [HomeTab.newTask] é ignorado por não ser uma aba de verdade.
  void select(HomeTab tab) {
    if (tab == HomeTab.newTask) return;
    _selectedTab.value = tab;
  }

  void dispose() => _selectedTab.dispose();
}
