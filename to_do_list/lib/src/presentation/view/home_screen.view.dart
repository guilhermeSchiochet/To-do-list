import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/presentation/controller/home_screen.controller.dart';
import 'package:to_do_list/src/presentation/widgets/my_app_bar.dart';
import 'package:to_do_list/src/presentation/widgets/my_button_bar.dart';
import 'package:animations/animations.dart';
import 'package:to_do_list/src/presentation/widgets/task_list_widgets.dart';
class HomeScreenView extends StatefulWidget {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  const HomeScreenView({super.key, required this.addTaskUseCase, required this.deleteTaskUseCase, required this.updateTaskUseCase});

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenView> with SingleTickerProviderStateMixin {

  final HomeScreenController _controller = HomeScreenController.instance;

  final ValueNotifier<List<TaskModel>> _tasksNotifier = ValueNotifier<List<TaskModel>>([]);

  @override
  void initState() {
    _loadTasks();
    super.initState();
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.addTaskUseCase.repository.getAllTasks();
    _tasksNotifier.value = _controller.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _conteudo(),
      bottomNavigationBar: _buttonBar(),
    );
  }
  
  MyAppBar _appBar() =>  const MyAppBar();

  Widget _buttonBar() {
    return ValueListenableBuilder(
      valueListenable: _controller.selectedIndex,
      builder: (context, value, child) => MyBottomBar(
        selectedIndex: _controller.selectedIndex.value,
        onTap: (index) => _controller.selectedIndex.value = index
      ),
    );
  }

  /// Retorna o widget que representa o conteúdo principal da tela
  Widget _conteudo() {
    return ValueListenableBuilder<List<TaskModel>>(
      valueListenable: _tasksNotifier,
      builder: (context, tasks, child) {
        return Column(
          children: [
            const SizedBox(height: 30),
            _builderListProjects(),
            const SizedBox(height: 30),
            Expanded(
              child: _buildTaskListWidget(tasks),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskListWidget(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('Nenhuma tarefa encontrada.'),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  children: const [
                    Text(
                      'Priority',
                      style: TextStyle(
                        color: Color.fromARGB(255, 65, 63, 63),
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            TaskListWidget(
              tasks: tasks,
              isPreview: true,
              showActions: true,
            ),
            Align(
              child: GestureDetector(
                onTap: () {
                  // Adicione aqui a ação ao clicar em "View All"
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 8.0),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
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
                  fontWeight: FontWeight.w800,
                  color: AppTheme.tituloPreto,
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
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _controller.cardProject.length,
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