import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/widgets/card_projects.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class HomeScreenController {
  static final HomeScreenController _instance = HomeScreenController._internal();

  HomeScreenController._internal();

  static HomeScreenController get instance => _instance;

  List<CardProjects> get cardProject {
    return [
      CardProjects(
        title: 'Contest Design',
        subtitle: 'Redesign and test',
        icon: Icons.emoji_objects_outlined,
        progress: 4,
        totalTasks: 10,
        color: Colors.orange,
      ),
      CardProjects(
        color: Colors.blue,
        icon: Icons.design_services_outlined,
        progress: 3,
        totalTasks: 10,
        title: 'Design System',
        subtitle: 'Create and test',
      ),
      CardProjects(
        color: Colors.green,
        icon: Icons.code_outlined,
        progress: 2,
        totalTasks: 10,
        title: 'Code Review',
        subtitle: 'Review and test',
      ),  
    ];
  }

  List<TaskModel> get tasks => [
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
  ];

}