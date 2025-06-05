import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final TaskPriority priority;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] == 1,
      priority: TaskPriority.values[json['priority']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority.index,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}
