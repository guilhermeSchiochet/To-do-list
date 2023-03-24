import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/app.dart';
import 'package:to_do_list/data/task_repository.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';
import 'package:to_do_list/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/domain/useCases/update_use_case.dart';

void main() {

  // Inicializa os casos de uso
  final taskRepository = TaskRepository();
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
