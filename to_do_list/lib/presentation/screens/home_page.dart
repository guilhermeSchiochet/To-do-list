import 'package:flutter/material.dart';
import 'package:to_do_list/data/task_repository.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';
import 'package:to_do_list/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/domain/useCases/update_use_case.dart';
import 'package:to_do_list/presentation/widgets/task_list_widgets.dart';

class HomePage extends StatefulWidget {
  final AddTaskUseCase _addTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;

  HomePage({
    Key? key
  }) :
    _addTaskUseCase = AddTaskUseCase(repository: TaskRepository()),
    _deleteTaskUseCase = DeleteTaskUseCase(repository: TaskRepository()),
    _updateTaskUseCase = UpdateTaskUseCase(repository: TaskRepository()),
    super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<TaskModel> _tasks;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    // Fetch tasks from the repository
    _tasks = await widget._addTaskUseCase.repository.getAllTasks();
    setState(() {});
  }

  /// Adds a new task.
  /// Adiciona uma nova tarefa.
  void _addTask() async {}

  /// Updates an existing task.
  /// Atualiza uma tarefa existente.
  void _updateTask(TaskModel task) async {
    await widget._updateTaskUseCase(task);

    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
    });
  }

  /// Deletes a task.
  /// Exclui uma tarefa.
  void _deleteTask(TaskModel task) async {
    await widget._deleteTaskUseCase(task);

    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do List'),
      ),
      body: _tasks.isEmpty ? const Center(child: Text('No tasks available')) : TaskListWidget(
        tasks: _tasks,
        onUpdate: _updateTask,
        onDelete: _deleteTask,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
