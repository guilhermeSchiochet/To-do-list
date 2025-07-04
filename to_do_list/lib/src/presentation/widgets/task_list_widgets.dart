import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/colors_extension.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class TaskListWidget extends StatelessWidget {
  /// Utilizado na [HomeScreenView] para demostrar somente um preview da lista. Irá demostrar os quatros (4) primeiros itens da lista.
  final bool isPreview;
  
  final bool showActions;
  final List<TaskModel> tasks;
  final Function(TaskModel)? onUpdate;
  final Function(TaskModel)? onDelete;

  const TaskListWidget({
    super.key,
    this.onUpdate,
    this.onDelete,
    required this.tasks,
    this.isPreview = false,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount:  isPreview ? 3 : tasks.length,
      physics: isPreview ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return _buildTaskTile(context, task);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
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
                            _buildInfoStatus(color: Colors.orangeAccent),
                            SizedBox(width: 4),
                            _buildInfoStatus(color: Colors.purple),
                            SizedBox(width: 4),
                            _buildInfoStatus(color: Colors.blue),
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
      color: color.withAlphaPercent(0.2),
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
      elevation: 0,
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
}