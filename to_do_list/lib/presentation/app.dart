import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/screens/home_page.dart';
import 'package:to_do_list/presentation/widgets/theme_app.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';
import 'package:to_do_list/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/domain/useCases/update_use_case.dart';

class App extends StatelessWidget {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  const App({
    Key? key,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        addTaskUseCase: addTaskUseCase,
        deleteTaskUseCase: deleteTaskUseCase,
        updateTaskUseCase: updateTaskUseCase,
      ),
      theme: ThemeApp.themeApp,
      debugShowCheckedModeBanner: false,
    );
  }
}
