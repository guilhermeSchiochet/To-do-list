import 'package:flutter/foundation.dart';
import 'package:to_do_list/src/data/services/notification_service.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/get_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';

/// Guarda a lista de tarefas em memória e mantém banco, lembretes e UI
/// em sincronia.
/// Holds the task list in memory and keeps database, reminders and UI in sync.
class TaskController {
  final GetTasksUseCase _getTasks;
  final AddTaskUseCase _addTask;
  final UpdateTaskUseCase _updateTask;
  final DeleteTaskUseCase _deleteTask;
  final NotificationService _notifications;

  TaskController({
    required GetTasksUseCase getTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    NotificationService? notificationService,
  })  : _getTasks = getTasksUseCase,
        _addTask = addTaskUseCase,
        _updateTask = updateTaskUseCase,
        _deleteTask = deleteTaskUseCase,
        _notifications = notificationService ?? NotificationService.instance;

  final ValueNotifier<List<TaskModel>> _tasks =
      ValueNotifier<List<TaskModel>>(const []);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  /// Todas as tarefas, já ordenadas pelo banco.
  ValueListenable<List<TaskModel>> get tasks => _tasks;

  /// Verdadeiro até a primeira leitura do banco terminar.
  ValueListenable<bool> get isLoading => _isLoading;

  /// Recarrega as tarefas a partir do banco.
  Future<void> load() async {
    _tasks.value = await _getTasks();
    _isLoading.value = false;
  }

  Future<void> add(TaskModel task) async {
    _tasks.value = [..._tasks.value, task];
    await _addTask(task);
    await _notifications.syncReminder(task);
    await load();
  }

  Future<void> update(TaskModel task) async {
    _tasks.value = [
      for (final saved in _tasks.value) saved.id == task.id ? task : saved,
    ];
    await _updateTask(task);
    await _notifications.syncReminder(task);
    await load();
  }

  /// A lista some com a tarefa antes da ida ao banco. Além de responder na
  /// hora, isso evita que a linha arrastada continue na árvore enquanto o
  /// `Dismissible` já a deu por removida.
  Future<void> delete(TaskModel task) async {
    _tasks.value =
        _tasks.value.where((saved) => saved.id != task.id).toList();
    await _deleteTask(task);
    await _notifications.cancelReminder(task);
    await load();
  }

  /// Marca ou desmarca a tarefa como concluída.
  Future<void> toggleCompleted(TaskModel task) =>
      update(task.copyWith(isCompleted: !task.isCompleted));

  /// Marca ou desmarca a sinalização da tarefa.
  Future<void> toggleFlag(TaskModel task) =>
      update(task.copyWith(isFlagged: !task.isFlagged));

  /// Devolve ao banco uma tarefa recém-excluída, para desfazer a ação.
  /// Puts a just-deleted task back, so the action can be undone.
  Future<void> restore(TaskModel task) => add(task);

  void dispose() {
    _tasks.dispose();
    _isLoading.dispose();
  }
}
