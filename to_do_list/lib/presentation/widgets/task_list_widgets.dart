import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        return _buildTaskItem(context, task);
      },
    );
  }

  /// Cria um item de tarefa com ações de arrastar e segurar.
  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(task),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
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
          Text(task.description),
          const SizedBox(height: 4),
          _buildTaskStatus(task),
        ],
      ),
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
      onLongPress: () => _toggleTaskCompletion(task),
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

  /// Alterna a conclusão da tarefa ao segurar em cima do item.
  void _toggleTaskCompletion(TaskModel task) {
    onUpdate(task.copyWith(isCompleted: !task.isCompleted));
  }

  /// Cria um ícone de prioridade colorido com base na prioridade da tarefa.
  Widget _buildPriorityIcon(TaskModel task) {
    Color iconColor;

    switch (task.priority) {
      case TaskPriority.high:
        iconColor = Colors.red;
        break;
      case TaskPriority.medium:
        iconColor = Colors.orange;
        break;
      case TaskPriority.low:
        iconColor = Colors.green;
        break;
      default:
        iconColor = Colors.grey;
        break;
    }

    return Icon(
      Icons.label,
      color: iconColor,
    );
  }
}