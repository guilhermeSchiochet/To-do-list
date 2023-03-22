import 'package:to_do_list/data/task_repository.dart';
import 'package:to_do_list/domain/model/task_model.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase({required this.repository});

  Future<void> call(TaskModel task) async {
    //return await repository.deleteTask(task);
  }
}
