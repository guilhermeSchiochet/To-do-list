import 'package:flutter/material.dart';
import 'package:to_do_list/domain/model/task_model.dart';

class TaskListWidget extends StatelessWidget {

  final List<TaskModel> tasks;
  final Function(TaskModel) onUpdate;
  final Function(TaskModel) onDelete;

  const TaskListWidget({
    Key? key,
    required this.tasks,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              onUpdate(task.copyWith(isCompleted: value!));
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(task),
          ),
        );
      },
    );
  }
}
