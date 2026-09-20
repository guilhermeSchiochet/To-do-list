import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/data/repositories/task_repository.dart';
import 'package:to_do_list/src/data/services/notification_service.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/get_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/presentation/controller/task_controller.dart';

/// Repositório em memória, para o controller ser testado sem o SQLite.
class _FakeRepository extends TaskRepository {
  final List<TaskModel> tasks = [];

  @override
  Future<void> addTask(TaskModel task) async => tasks.add(task);

  @override
  Future<List<TaskModel>> getAllTasks() async => List.of(tasks);

  @override
  Future<void> updateTask(TaskModel task) async {
    final index = tasks.indexWhere((saved) => saved.id == task.id);
    if (index != -1) tasks[index] = task;
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    tasks.removeWhere((saved) => saved.id == task.id);
  }
}

/// Registra os lembretes pedidos sem acionar o plugin nativo.
class _FakeNotificationService extends NotificationService {
  final List<String> synced = [];
  final List<String> cancelled = [];

  @override
  Future<void> syncReminder(TaskModel task) async => synced.add(task.id);

  @override
  Future<void> cancelReminder(TaskModel task) async => cancelled.add(task.id);
}

void main() {
  late _FakeRepository repository;
  late _FakeNotificationService notifications;
  late TaskController controller;

  setUp(() {
    repository = _FakeRepository();
    notifications = _FakeNotificationService();
    controller = TaskController(
      getTasksUseCase: GetTasksUseCase(repository: repository),
      addTaskUseCase: AddTaskUseCase(repository: repository),
      updateTaskUseCase: UpdateTaskUseCase(repository: repository),
      deleteTaskUseCase: DeleteTaskUseCase(repository: repository),
      notificationService: notifications,
    );
  });

  tearDown(() => controller.dispose());

  TaskModel task(String id, {bool isCompleted = false, bool isFlagged = false}) {
    return TaskModel(
      id: id,
      title: 'Task $id',
      isCompleted: isCompleted,
      isFlagged: isFlagged,
    );
  }

  test('começa carregando e termina com a lista do banco', () async {
    repository.tasks.add(task('1'));
    expect(controller.isLoading.value, isTrue);

    await controller.load();

    expect(controller.isLoading.value, isFalse);
    expect(controller.tasks.value.single.id, '1');
  });

  test('add grava a tarefa e agenda o lembrete', () async {
    await controller.add(task('1'));

    expect(repository.tasks.single.id, '1');
    expect(controller.tasks.value.single.id, '1');
    expect(notifications.synced, ['1']);
  });

  test('toggleCompleted inverte a conclusão e persiste', () async {
    await controller.add(task('1'));

    await controller.toggleCompleted(controller.tasks.value.single);

    expect(controller.tasks.value.single.isCompleted, isTrue);
    expect(repository.tasks.single.isCompleted, isTrue);
  });

  test('toggleFlag inverte a sinalização', () async {
    await controller.add(task('1'));

    await controller.toggleFlag(controller.tasks.value.single);

    expect(controller.tasks.value.single.isFlagged, isTrue);
  });

  test('delete remove a tarefa e cancela o lembrete', () async {
    await controller.add(task('1'));

    await controller.delete(controller.tasks.value.single);

    expect(controller.tasks.value, isEmpty);
    expect(notifications.cancelled, ['1']);
  });

  test('restore devolve a tarefa excluída', () async {
    final original = task('1', isFlagged: true);
    await controller.add(original);
    await controller.delete(original);

    await controller.restore(original);

    expect(controller.tasks.value.single, original);
  });
}
