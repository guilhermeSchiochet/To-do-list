import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Lê todas as tarefas salvas.
/// Reads every saved task.
class GetTasksUseCase {
  final TaskRepository _repository;

  GetTasksUseCase({required TaskRepository repository})
      : _repository = repository;

  Future<List<TaskModel>> call() => _repository.getAllTasks();
}
