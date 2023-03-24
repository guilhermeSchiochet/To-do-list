import 'package:flutter/material.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';
import 'package:to_do_list/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/domain/useCases/update_use_case.dart';
import 'package:to_do_list/presentation/screens/add_task_page.dart';
import 'package:to_do_list/presentation/screens/comple_task_page.dart';
import 'package:to_do_list/presentation/widgets/my_app_bar.dart';
import 'package:to_do_list/presentation/widgets/task_list_widgets.dart';

class HomePage extends StatefulWidget {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  const HomePage({
    Key? key,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  }) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ValueNotifier<List<TaskModel>> _tasksNotifier = ValueNotifier<List<TaskModel>>([]);
  bool _dataLoaded = false;

  @override
  void initState() {
    _loadTasks();
    super.initState();
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.addTaskUseCase.repository.getAllTasks();
    _tasksNotifier.value = tasks;
    _dataLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _conteudo(),
      bottomNavigationBar: _buildBottomAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  MyAppBar _appBar() {
    return const MyAppBar();
  }

  Widget _conteudo() {
    return ValueListenableBuilder<List<TaskModel>>(
      valueListenable: _tasksNotifier,
      builder: (context, tasks, child) {
        if (!_dataLoaded) {
          return const Center(child: CircularProgressIndicator());
        } else if (tasks.isEmpty) {
          return const Center(child: Text('Nenhuma tarefa encontrada.'));
        } else {
          return TaskListWidget(
            tasks: tasks,
            onUpdate: (e) {},
            onDelete: (e) {},
          );
        }
      },
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.archive, size: 31),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.library_add_check_outlined, size: 31),
            onPressed: _navigateToCompletedTasks,
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToAddTaskPage,
      child: const Icon(Icons.add,),
    );
  }

  void _navigateToCompletedTasks() {
    widget.addTaskUseCase.repository.getAllTasks().then((allTasks) {
      final completedTasks = allTasks.where((task) => task.isCompleted).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompletedTasksPage(completedTasks: completedTasks),
        ),
      );
    });
  }

  void _navigateToAddTaskPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          addTaskUseCase: widget.addTaskUseCase,
        ),
      ),
    );
    _loadTasks();
  }
}