import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase({required this.repository});

  void call(TaskModel task) => repository.updateTask(task);
}
