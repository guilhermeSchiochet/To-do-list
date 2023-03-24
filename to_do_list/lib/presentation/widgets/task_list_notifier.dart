import 'package:flutter/material.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';

class TaskListNotifier extends ChangeNotifier {
  final AddTaskUseCase _addTaskUseCase;

  TaskListNotifier({required AddTaskUseCase addTaskUseCase}) : _addTaskUseCase = addTaskUseCase;

  Future<List<TaskModel>> loadTasks() async {
    return await _addTaskUseCase.repository.getAllTasks();
  }

  void updateTasks() {
    notifyListeners();
  }
}
