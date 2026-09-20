import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/data/services/notification_service.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/get_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/presentation/app.dart';
import 'package:to_do_list/src/presentation/controller/task_controller.dart';
import 'package:to_do_list/src/presentation/controller/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop não traz o sqflite nativo; o FFI cobre Windows e Linux.
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await NotificationService.instance.initialize();

  final repository = TaskRepository();
  final taskController = TaskController(
    getTasksUseCase: GetTasksUseCase(repository: repository),
    addTaskUseCase: AddTaskUseCase(repository: repository),
    updateTaskUseCase: UpdateTaskUseCase(repository: repository),
    deleteTaskUseCase: DeleteTaskUseCase(repository: repository),
  );

  // O tema é lido antes do primeiro quadro para o app não piscar em claro
  // quando o usuário escolheu escuro.
  final themeController = ThemeController();
  await themeController.load();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => 
      App(
        taskController: taskController,
        themeController: themeController,
      ),
    // ),
  );
}
