import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/data/services/preferences_service.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

/// Um atalho do topo da tela Lists, como "Today" ou "Flagged".
/// A shortcut at the top of the Lists screen.
@immutable
class SmartList {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;

  const SmartList({
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
  });
}

/// Estado da tela Lists.
/// State of the Lists screen.
@immutable
class ListsState {
  /// Listas que o usuário escondeu.
  final Set<TaskCategory> hidden;

  /// Se o modo de edição está ligado.
  final bool isEditing;

  const ListsState({this.hidden = const {}, this.isEditing = false});

  ListsState copyWith({Set<TaskCategory>? hidden, bool? isEditing}) {
    return ListsState(
      hidden: hidden ?? this.hidden,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

/// Monta os atalhos e as listas do usuário, e lembra quais ele escondeu.
/// Builds the shortcuts and the user's lists, remembering the hidden ones.
class ListsController {
  final PreferencesService _preferences;

  ListsController({PreferencesService? preferencesService})
      : _preferences = preferencesService ?? PreferencesService();

  final ValueNotifier<ListsState> _state =
      ValueNotifier<ListsState>(const ListsState());

  ValueListenable<ListsState> get state => _state;

  /// Recupera as listas escondidas das preferências.
  Future<void> load() async {
    _state.value =
        _state.value.copyWith(hidden: await _preferences.loadHiddenCategories());
  }

  void toggleEditing() =>
      _state.value = _state.value.copyWith(isEditing: !_state.value.isEditing);

  void toggleHidden(TaskCategory category) {
    final hidden = Set<TaskCategory>.of(_state.value.hidden);
    hidden.contains(category) ? hidden.remove(category) : hidden.add(category);

    _state.value = _state.value.copyWith(hidden: hidden);
    _preferences.saveHiddenCategories(hidden);
  }

  /// Os quatro atalhos do topo, com as tarefas de cada um.
  List<SmartList> smartLists(List<TaskModel> tasks) {
    return [
      SmartList(
        title: strings.smartListToday,
        icon: Icons.calendar_today_rounded,
        color: AppPalette.primary,
        tasks: tasks.forToday,
      ),
      SmartList(
        title: strings.smartListScheduled,
        icon: Icons.schedule_rounded,
        color: AppPalette.red,
        tasks: tasks.scheduled,
      ),
      SmartList(
        title: strings.smartListAll,
        icon: Icons.inbox_rounded,
        color: AppPalette.gray,
        tasks: tasks,
      ),
      SmartList(
        title: strings.smartListFlagged,
        icon: Icons.flag_rounded,
        color: AppPalette.orange,
        tasks: tasks.flagged,
      ),
    ];
  }

  /// Listas exibidas. No modo de edição todas aparecem, senão não haveria
  /// como reexibir uma que foi escondida.
  List<TaskCategory> visibleCategories() {
    final current = _state.value;
    if (current.isEditing) return TaskCategory.values;

    return TaskCategory.values
        .where((category) => !current.hidden.contains(category))
        .toList();
  }

  void dispose() => _state.dispose();
}
