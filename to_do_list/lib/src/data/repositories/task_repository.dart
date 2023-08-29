import 'package:to_do_list/src/data/providers/task_provider.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// TaskRepository is responsible for connecting use cases with the data providers.
/// O TaskRepository é responsável por conectar os use cases com os provedores de dados.
class TaskRepository {
  final TaskProvider _taskProvider = TaskProvider();

  /// Adds a task to the database.
  /// Adiciona uma tarefa ao banco de dados.
  Future<void> addTask(TaskModel task) async {
    await _taskProvider.addTask(task);
  }

  /// Retrieves all tasks from the database.
  /// Recupera todas as tarefas do banco de dados.
  Future<List<TaskModel>> getAllTasks() async {
    return await _taskProvider.getAllTasks();
  }

  /// Updates a task in the database.
  /// Atualiza uma tarefa no banco de dados.
  Future<void> updateTask(TaskModel task) async {
    await _taskProvider.updateTask(task);
  }

  /// Deletes a task from the database.
  /// Exclui uma tarefa do banco de dados.
  Future<void> deleteTask(TaskModel task) async {
    await _taskProvider.deleteTask(task.id);
  }
}
