import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/presentation/controller/home_screen.controller.dart';
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

  final HomeScreenController _controller = HomeScreenController.instance;

  final ValueNotifier<List<TaskModel>> _tasksNotifier = ValueNotifier<List<TaskModel>>([]);

  @override
  void initState() {
    _loadTasks();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  MyAppBar _appBar() =>  const MyAppBar();

  /// Retorna o widget que representa o conteúdo principal da tela
  Widget _conteudo() {
    return ValueListenableBuilder<List<TaskModel>>(
      valueListenable: _tasksNotifier,
      builder: (context, tasks, child) {
        return _getTaskTabsWidget(tasks);
      },
    );
  }

  /// Retorna o widget da lista de tarefas baseado na lista de tarefas passada
  Widget _buildTaskListWidget(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa encontrada.'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 15,
          children: [
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
            TaskListWidget(
              tasks: tasks,
            ),
          ]
        ),
      );
    }
  }

  /// Retorna o widget que contém as tabs das tarefas pendentes e concluídas
  Widget _getTaskTabsWidget(List<TaskModel> tasks) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _builderListProjects(),
          _buildTaskListWidget(tasks)
        ]
      ),
    );
  }

  Widget _builderListProjects() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
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
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15
          ),
          child: SizedBox(
            height: 200,
            child: ListView.separated(
              itemCount: _controller.cardProject.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _controller.cardProject[index];
              },
            ),
          ),
        ),
      ]
    );
  }


}