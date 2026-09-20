import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Salva uma nova tarefa.
/// Saves a new task.
class AddTaskUseCase {
  final TaskRepository _repository;

  AddTaskUseCase({required TaskRepository repository})
      : _repository = repository;

  Future<void> call(TaskModel task) => _repository.addTask(task);
}
