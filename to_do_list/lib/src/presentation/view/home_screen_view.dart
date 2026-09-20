import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/layout/app_layout.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/home_screen_controller.dart';
import 'package:to_do_list/src/presentation/controller/task_controller.dart';
import 'package:to_do_list/src/presentation/controller/theme_controller.dart';
import 'package:to_do_list/src/presentation/view/calendar_view.dart';
import 'package:to_do_list/src/presentation/view/lists_view.dart';
import 'package:to_do_list/src/presentation/view/search_view.dart';
import 'package:to_do_list/src/presentation/view/settings_view.dart';
import 'package:to_do_list/src/presentation/view/task_editor_view.dart';
import 'package:to_do_list/src/presentation/view/today_view.dart';
import 'package:to_do_list/src/presentation/widgets/content_column.dart';
import 'package:to_do_list/src/presentation/widgets/my_button_bar.dart';
import 'package:to_do_list/src/presentation/widgets/my_navigation_rail.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Tela principal: hospeda as abas e concentra as ações sobre as tarefas.
/// Main screen: hosts the tabs and centralizes the task actions.
class HomeScreenView extends StatefulWidget {
  final TaskController taskController;
  final ThemeController themeController;

  const HomeScreenView({
    super.key,
    required this.taskController,
    required this.themeController,
  });

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final HomeScreenController _navigation = HomeScreenController();
  late final TaskActions _actions = TaskActions(
    toggleCompleted: widget.taskController.toggleCompleted,
    toggleFlag: widget.taskController.toggleFlag,
    delete: _deleteWithUndo,
    edit: _editTask,
  );

  @override
  void initState() {
    super.initState();
    widget.taskController.load();
  }

  @override
  void dispose() {
    _navigation.dispose();
    super.dispose();
  }

  /// Exclui a tarefa oferecendo desfazer, já que o gesto de arrastar é fácil
  /// de disparar sem querer.
  void _deleteWithUndo(TaskModel task) {
    widget.taskController.delete(task);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(strings.taskDeleted),
          action: SnackBarAction(
            label: strings.undo,
            onPressed: () => widget.taskController.restore(task),
          ),
        ),
      );
  }

  Future<void> _editTask(TaskModel task) async {
    final edited = await TaskEditorView.show(
      context,
      task: task,
      onDelete: () => _deleteWithUndo(task),
    );

    if (edited != null) await widget.taskController.update(edited);
  }

  Future<void> _createTask({DateTime? initialDate}) async {
    final created = await TaskEditorView.show(context, initialDate: initialDate);

    if (created != null) await widget.taskController.add(created);
  }

  void _openSearch(List<TaskModel> tasks) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchView(tasks: tasks, actions: _actions),
      ),
    );
  }

  void _onTabTap(HomeTab tab) {
    if (tab == HomeTab.newTask) {
      _createTask();
      return;
    }
    _navigation.select(tab);
  }

  @override
  Widget build(BuildContext context) {
    // Numa janela larga a navegação vai para a lateral e a barra inferior
    // sai de cena, então não há nada translúcido para o corpo passar por baixo.
    final isExpanded = context.isExpandedLayout;

    return Scaffold(
      extendBody: !isExpanded,
      body: ValueListenableBuilder<HomeTab>(
        valueListenable: _navigation.selectedTab,
        builder: (context, tab, _) {
          return ValueListenableBuilder<List<TaskModel>>(
            valueListenable: widget.taskController.tasks,
            builder: (context, tasks, _) {
              return SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    if (isExpanded)
                      MyNavigationRail(selectedTab: tab, onTap: _onTabTap),
                    Expanded(
                      child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 320),
                        transitionBuilder:
                            (child, animation, secondaryAnimation) =>
                                FadeThroughTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          fillColor: Colors.transparent,
                          child: child,
                        ),
                        child: KeyedSubtree(
                          key: ValueKey<HomeTab>(tab),
                          child: ContentColumn(child: _viewFor(tab, tasks)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: isExpanded
          ? null
          : ValueListenableBuilder<HomeTab>(
              valueListenable: _navigation.selectedTab,
              builder: (context, tab, _) => MyBottomBar(
                selectedTab: tab,
                onTap: _onTabTap,
              ),
            ),
    );
  }

  Widget _viewFor(HomeTab tab, List<TaskModel> tasks) {
    return switch (tab) {
      HomeTab.calendar => CalendarView(
          tasks: tasks,
          actions: _actions,
          onAddTask: (date) => _createTask(initialDate: date),
          onSearchPressed: () => _openSearch(tasks),
        ),
      HomeTab.lists => ListsView(tasks: tasks, actions: _actions),
      HomeTab.settings =>
        SettingsView(themeController: widget.themeController),
      // `newTask` abre uma folha em vez de trocar de aba, então cai em Today.
      HomeTab.today || HomeTab.newTask => TodayView(
          tasks: tasks,
          actions: _actions,
          onSearchPressed: () => _openSearch(tasks),
          onProfilePressed: () => _navigation.select(HomeTab.settings),
        ),
    };
  }
}
