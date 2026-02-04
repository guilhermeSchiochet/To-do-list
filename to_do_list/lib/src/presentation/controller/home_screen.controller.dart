import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class HomeScreenController {
  static final HomeScreenController _instance = HomeScreenController._internal();

  HomeScreenController._internal();

  static HomeScreenController get instance => _instance;

  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

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