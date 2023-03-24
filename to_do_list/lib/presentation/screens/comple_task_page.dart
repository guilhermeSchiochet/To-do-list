import 'package:flutter/material.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/presentation/widgets/task_list_widgets.dart';

class CompletedTasksPage extends StatefulWidget {
  final List<TaskModel> completedTasks;

  const CompletedTasksPage({Key? key, required this.completedTasks}) : super(key: key);

  @override
  createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas concluídas'),
      ),
      body: TaskListWidget(
        tasks: widget.completedTasks,
        onUpdate: (task) {},
        onDelete: (task) {},
      ),
    );
  }
}
