import 'package:to_do_list/src/data/providers/task_provider.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Conecta os casos de uso aos provedores de dados.
/// Connects the use cases to the data providers.
class TaskRepository {
  final TaskProvider _taskProvider;

  TaskRepository({TaskProvider? taskProvider})
      : _taskProvider = taskProvider ?? TaskProvider();

  /// Adiciona uma tarefa ao banco de dados.
  /// Adds a task to the database.
  Future<void> addTask(TaskModel task) => _taskProvider.addTask(task);

  /// Recupera todas as tarefas do banco de dados.
  /// Retrieves all tasks from the database.
  Future<List<TaskModel>> getAllTasks() => _taskProvider.getAllTasks();

  /// Atualiza uma tarefa no banco de dados.
  /// Updates a task in the database.
  Future<void> updateTask(TaskModel task) => _taskProvider.updateTask(task);

  /// Exclui uma tarefa do banco de dados.
  /// Deletes a task from the database.
  Future<void> deleteTask(TaskModel task) => _taskProvider.deleteTask(task.id);
}
