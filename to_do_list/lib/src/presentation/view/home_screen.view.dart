import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/presentation/screens/add_task_screen.dart';
import 'package:to_do_list/src/presentation/widgets/card_projects.dart';
import 'package:to_do_list/src/presentation/widgets/my_app_bar.dart';
import 'package:to_do_list/src/presentation/widgets/task_list_widgets.dart';
import 'package:to_do_list/src/utils/extensions/colors_extension.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class HomeScreen extends StatefulWidget {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  const HomeScreen({super.key, required this.addTaskUseCase, required this.deleteTaskUseCase, required this.updateTaskUseCase});

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

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
        tasks: [
            TaskModel(
              id: 'teste',
              title: 'Video Player Design',
              description: 'Ckeck task with all',
              priority: TaskPriority.high
            ),
            TaskModel(
              id: 'teste1',
              title: 'Admin Panel Design',
              description: 'Create a design for the admin panel',
              priority: TaskPriority.medium
            ),
            TaskModel(
              id: 'teste3',
              title: 'Buying Spotyfy and Apple Music premium',
              priority: TaskPriority.low
            ),
        ],
        onUpdate: onUpdate,
        onDelete: onDelete,
      );
    }
  }

  /// Retorna o widget que contém as tabs das tarefas pendentes e concluídas
  Widget _getTaskTabsWidget(List<TaskModel> tasks) {
    return Column(
      children: [
        // TabBar(
        //   controller: _tabController,
        //   labelColor: Colors.black,
        //   indicatorColor: Colors.grey,
        //   dividerColor: Colors.transparent,
        //   onTap: (v) =>_valueValidate.value = v,
          
        //   unselectedLabelColor: Colors.grey.shade700,
        //   overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        //   tabs: const [
        //     Tab(text: 'Em Progresso'),
        //     Tab(text: 'Concluído')
        //   ],
        // ),
         Row(
          children: [
            Text(
              'Projects',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 65, 63, 63),
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Text(
              'View All',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardProjects(
              title: 'Contest Design',
              subtitle: 'Redesign and test',
              icon: Icons.emoji_objects_outlined,
              progress: 4,
              totalTasks: 10,
              color: Colors.orange,
            ),
            CardProjects(
              title: 'App Design',
              subtitle: 'Design and test',
              icon: Icons.design_services_outlined,
              progress: 2,
              totalTasks: 10,
              color: Colors.blue,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Today Tasks',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: const Color.fromARGB(255, 65, 63, 63),
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Priority',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 65, 63, 63),
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ValueListenableBuilder<List<TaskModel>>(
        valueListenable: _tasksNotifier,
        builder: (context, tasks, child) {
          return _getTaskTabsWidget(tasks);
        },
      ),
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
        builder: (context) => AddTaskScreen(
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