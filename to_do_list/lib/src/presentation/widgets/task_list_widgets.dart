import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/screens/add_task_page.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class TaskListWidget extends StatelessWidget {

  final bool showActions;
  final List<TaskModel> tasks;
  final Function(TaskModel)? onUpdate;
  final Function(TaskModel)? onDelete;

  const TaskListWidget({
    Key? key,
    this.onUpdate,
    this.onDelete,
    required this.tasks,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(context, task);
      },
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (context) => onDelete!(task),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: showActions ? null : ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (context) => onUpdate!(task.copyWith(isCompleted: true)),
            backgroundColor: const Color.fromARGB(255, 16, 235, 107),
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Complete',
          ),
        ],
      ),
      child: _buildTaskTile(context, task),
    );
  }

  /// Cria um ListTile para a tarefa com ações de clique e segurar.
  Widget _buildTaskTile(BuildContext context, TaskModel task) {
    return ListTile(
      title: Row(
        children: [
          _buildPriorityIcon(task),
          const SizedBox(width: 8),
          Text(task.title),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.description,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildTaskStatus(task),
        ],
      ),
      leading: task.isCompleted ? CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.2),
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            'C',
            style: TextStyle(
              color: Colors.green, 
              fontSize: 16,
            ),
          ),
        ),
      ) : Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          onUpdate!(task.copyWith(isCompleted: value!));
        },
      ),
      trailing: showActions ? null : IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete!(task),
      ),
      onTap: () => _openTaskDetails(context, task)
    );
  }


  /// Cria um indicador de status para a tarefa.
  Widget _buildTaskStatus(TaskModel task) {
    String statusText;
    Color statusColor;

    if (task.isCompleted) {
      statusText = 'Concluído';
      statusColor = Colors.green;
    } else {
      statusText = 'Pendente';
      statusColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: statusColor, fontSize: 12),
      ),
    );
  }

  /// Cria um ícone de prioridade colorido com base na prioridade da tarefa.
  Widget _buildPriorityIcon(TaskModel task) {
    return Icon(
      Icons.label,
      color: task.priority.color,
    );
  }

  void _openTaskDetails(BuildContext context, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          task: task,
          readOnly: true
        ),
      ),
    );
  }
}