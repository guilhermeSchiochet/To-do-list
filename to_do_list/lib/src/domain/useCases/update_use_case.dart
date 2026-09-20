import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Grava as alterações de uma tarefa existente.
/// Persists the changes of an existing task.
class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase({required TaskRepository repository})
      : _repository = repository;

  Future<void> call(TaskModel task) => _repository.updateTask(task);
}
