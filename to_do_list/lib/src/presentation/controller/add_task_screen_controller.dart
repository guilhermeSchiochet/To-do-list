import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class AddTaskScreenController {
  AddTaskScreenController({
    TaskModel? task,
    AddTaskUseCase? addTaskUseCase,
  }) {
    //_addTaskUseCase = addTaskUseCase;

    selectedPriority = task?.priority ?? TaskPriority.low;

    titleController = TextEditingController(text: task?.title ?? '');

    descriptionController =
        TextEditingController(text: task?.description ?? '');

    dueDate = task?.dateTime;
  }

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  final ValueNotifier<bool> remindMe = ValueNotifier(false);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TaskPriority selectedPriority = TaskPriority.low;
  DateTime? dueDate;

  //AddTaskUseCase? _addTaskUseCase;

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    remindMe.dispose();
  }

  void onPrioritySelected(TaskPriority priority) {
    selectedPriority = priority;
  }

  void onDateSelected(DateTime? date) {
    dueDate = date;
  }

  void onRemindChanged(bool value) {
    remindMe.value = value;
  }

  void onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> onAdd(BuildContext context) async {
  //  if (_addTaskUseCase == null) return;

    if (!formKey.currentState!.validate()) {
      return;
    }

    final task = TaskModel(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      priority: selectedPriority,
      id: '',
    );

   // _addTaskUseCase?.call(task);

    Navigator.pop(context);
  }
}
