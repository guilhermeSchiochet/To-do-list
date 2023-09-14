import 'package:flutter/material.dart';
import 'package:to_do_list/src/presentation/app.dart';
import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';

void main() {

  final taskRepository = TaskRepository();

  // Inicializa os casos de uso
  final addTaskUseCase = AddTaskUseCase(repository: taskRepository);
  final deleteTaskUseCase = DeleteTaskUseCase(repository: taskRepository);
  final updateTaskUseCase = UpdateTaskUseCase(repository: taskRepository);

  runApp(
    App(
      addTaskUseCase: addTaskUseCase,
      deleteTaskUseCase: deleteTaskUseCase,
      updateTaskUseCase: updateTaskUseCase,
    )
  );
}
