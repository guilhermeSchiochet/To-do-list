import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/screens/add_task_screen.dart';
import 'package:to_do_list/src/utils/extensions/colors_extension.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class TaskListWidget extends StatelessWidget {

  final bool showActions;
  final List<TaskModel> tasks;
  final Function(TaskModel)? onUpdate;
  final Function(TaskModel)? onDelete;

  const TaskListWidget({
    super.key,
    this.onUpdate,
    this.onDelete,
    required this.tasks,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(context, task);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return _buildTaskTile(context, task);
  }

  Widget _buildTaskTile(BuildContext context, TaskModel task) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: task.isCompleted,
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (bool? value) {
                        onUpdate!(task.copyWith(isCompleted: value!));
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              if(task.description != null) Text(
                                task.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),    
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildInfoStatus(color: Colors.green),
                            SizedBox(width: 4),
                            _buildInfoStatus(color: Colors.pink),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _buildpriority(
                  text: task.priority.toShortString(),
                  color: task.priority.color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoStatus({required Color color}) {
    return _baseBuild(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 4.0),
      text: "#Task",
      color: color.lighten(40),
      colorText: color
    );
  }

  Widget _buildpriority({required Color color, required String text}) {
    return _baseBuild(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 4.0),
      text: text,
      color: color,
    );
  }

  Widget _baseBuild({required EdgeInsetsGeometry padding, required String text, required Color color, Color colorText = Colors.white}) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(
            color: colorText,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),  
        ),
      ),
    );
  }

  /// Cria um ListTile para a tarefa com ações de clique e segurar.
  Widget _buildTaskTile2(BuildContext context, TaskModel task) {
    return ListTile(
      style: ListTileStyle.list,
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
          if(task.description != null) Text(
            task.description!,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildTaskStatus(task),
        ],
      ),
      leading: task.isCompleted ? CircleAvatar(
        backgroundColor: Colors.green.withValues(alpha: 0.2),
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
        color: statusColor.withValues(alpha: 0.2),
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
        builder: (context) => AddTaskScreen(
          task: task,
          readOnly: true
        ),
      ),
    );
  }
}