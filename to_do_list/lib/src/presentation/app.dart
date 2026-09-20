import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/presentation/controller/task_controller.dart';
import 'package:to_do_list/src/presentation/controller/theme_controller.dart';
import 'package:to_do_list/src/presentation/view/home_screen_view.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Raiz da árvore de widgets.
/// Root of the widget tree.
class App extends StatelessWidget {
  final TaskController taskController;
  final ThemeController themeController;

  const App({
    super.key,
    required this.taskController,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.mode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: strings.appTitle,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          home: HomeScreenView(
            taskController: taskController,
            themeController: themeController,
          ),
        );
      },
    );
  }
}
