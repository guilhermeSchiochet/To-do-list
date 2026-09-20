import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/widgets/content_column.dart';
import 'package:to_do_list/src/presentation/widgets/screen_app_bar.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';

/// Uma lista já filtrada, aberta ao tocar em um atalho ou categoria na tela
/// Lists.
/// An already filtered list, opened from a shortcut or category in the
/// Lists screen.
class FilteredTasksView extends StatelessWidget {
  final String title;
  final List<TaskModel> tasks;
  final TaskActions actions;

  const FilteredTasksView({
    super.key,
    required this.title,
    required this.tasks,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: title),
      body: SafeArea(
        child: ContentColumn(
          child: TaskList(tasks: tasks, actions: actions, bottomPadding: 32),
        ),
      ),
    );
  }
}
