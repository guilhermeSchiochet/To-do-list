import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/presentation/screens/add_task_screen.dart';
import 'package:to_do_list/src/presentation/screens/home_screen.view.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/utils/constants/strings.dart';
import 'package:to_do_list/src/utils/theme_controller.dart';

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
    final controller = ThemeController();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) =>MaterialApp(
        title: appTitle,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: controller.theme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreenView(
            addTaskUseCase: addTaskUseCase,
            deleteTaskUseCase: deleteTaskUseCase,
            updateTaskUseCase: updateTaskUseCase,
          ),
          '/add': (context) => AddTaskScreen(),
        },
      )

    );
  }
}
