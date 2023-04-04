import 'package:flutter/material.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';
import 'package:to_do_list/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/domain/useCases/update_use_case.dart';
import 'package:to_do_list/presentation/screens/add_task_page.dart';
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final ValueNotifier<List<TaskModel>> _tasksNotifier = ValueNotifier<List<TaskModel>>([]);

  late TabController _tabController;

  final ValueNotifier<int> _valueValidate = ValueNotifier(0);

  @override
  void initState() {
    _loadTasks();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.addTaskUseCase.repository.getAllTasks();
    _tasksNotifier.value = tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _conteudo(),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  MyAppBar _appBar() =>  const MyAppBar();

  /// Retorna uma lista de tarefas pendentes baseada na lista de tarefas passada
  List<TaskModel> _getPendingTasks(List<TaskModel> tasks) {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  /// Retorna uma lista de tarefas concluídas baseada na lista de tarefas passada
  List<TaskModel> _getCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isCompleted).toList();
  }

  /// Retorna o widget da lista de tarefas baseado na lista de tarefas passada
  Widget _getTaskListWidget(List<TaskModel> tasks, dynamic Function(TaskModel task) onUpdate, dynamic Function(TaskModel task) onDelete) {
    if (tasks.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa encontrada.'));
    } else {
      return TaskListWidget(
        tasks: tasks,
        onUpdate: onUpdate,
        onDelete: onDelete,
      );
    }
  }

  /// Retorna o widget que contém as tabs das tarefas pendentes e concluídas
  Widget _getTaskTabsWidget(List<TaskModel> tasks) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.grey,
          dividerColor: Colors.transparent,
          onTap: (v) =>_valueValidate.value = v,
          
          unselectedLabelColor: Colors.grey.shade700,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          tabs: const [
            Tab(text: 'Em Progresso'),
            Tab(text: 'Concluído')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              _getTaskListWidget(_getPendingTasks(tasks), _updateTask, _deleteTask),
              _getTaskListWidget(_getCompletedTasks(tasks), _updateTask, _deleteTask),
            ],
          ),
        ),
      ]
    );
  }

  /// Retorna o widget que exibe a lista de tarefas baseado na lista de tarefas passada
  Widget _getTaskList() {
    return ValueListenableBuilder<List<TaskModel>>(
      valueListenable: _tasksNotifier,
      builder: (context, tasks, child) {
        return _getTaskTabsWidget(tasks);
      },
    );
  }

  /// Retorna o widget que representa o conteúdo principal da tela
  Widget _conteudo() => _getTaskList();

  Widget _buildBottomBar() {
    return AnimatedBuilder(
      animation: _valueValidate,
      builder: (context, child) {
        if (_tabController.index == 0) {
          return const BottomAppBar(
            height: 60,
            shape: CircularNotchedRectangle(),
          );
        } else {
          return const AnimatedOpacity(
            opacity: 1,
            duration: Duration(seconds: 2),
            child: SizedBox(),
          );
        }
      },
    );
  }

  /// button create
  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _valueValidate,
      builder: (context, child) {
        if (_tabController.index == 0) {
          return SizedBox(
            width: 120,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey.shade300,
              onPressed: _navigateToAddTaskPage,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const AnimatedOpacity(
            opacity: 1,
            duration: Duration(seconds: 2),
            child: SizedBox(),
          );
        }
      },
    );
  }

  /// Navigate to page add
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

  /// Delete task 
  void _deleteTask(TaskModel task) {
    widget.deleteTaskUseCase.call(task);
    _loadTasks();
  }

  /// Uptade task 
  void _updateTask(TaskModel task) {
    widget.updateTaskUseCase.call(task);
    _loadTasks();
  }

}