import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/presentation/view/home_screen.view.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/utils/constants/strings.dart';

class App extends StatelessWidget {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  const App({
    super.key,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: HomeScreen(
        addTaskUseCase: addTaskUseCase,
        deleteTaskUseCase: deleteTaskUseCase,
        updateTaskUseCase: updateTaskUseCase,
      ),
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
