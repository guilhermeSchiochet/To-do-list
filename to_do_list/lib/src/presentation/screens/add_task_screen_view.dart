import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/presentation/controller/add_task_screen_controller.dart';
import 'package:to_do_list/src/presentation/widgets/date_form_field.dart';
import 'package:to_do_list/src/presentation/widgets/default_container.dart';
import 'package:to_do_list/src/presentation/widgets/priority_buttons.dart';

class AddTaskScreenView extends StatefulWidget {
  final bool readOnly;
  final TaskModel? task;
  final AddTaskUseCase? addTaskUseCase;

  const AddTaskScreenView({
    super.key,
    this.task,
    this.addTaskUseCase,
    this.readOnly = false,
  });

  @override
  State<AddTaskScreenView> createState() => _AddTaskScreenViewState();
}

class _AddTaskScreenViewState extends State<AddTaskScreenView> {
  late final AddTaskScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddTaskScreenController(
      task: widget.task,
      addTaskUseCase: widget.addTaskUseCase,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  /// Builds the top AppBar with Cancel and Add actions.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _controller.onCancel(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _controller.onAdd(context),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the body content including title, inputs and sections.
  Widget _buildBody(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New Task',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.tituloPreto,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildContainerTitleAndNotes(),
            const SizedBox(height: 32),
            _buildContainerPriorityAndDate(),
            const SizedBox(height: 32),
            _buildContainerRemind(),
          ],
        ),
      ),
    );
  }

  /// Builds the container with title and description fields.
  Widget _buildContainerTitleAndNotes() {
    return DefaultContainer(
      activeDivider: true,
      children: [
        TextFormField(
          controller: _controller.titleController,
          decoration: const InputDecoration(
            hintText: 'Title',
          ),
        ),
        TextFormField(
          maxLines: 3,
          controller: _controller.descriptionController,
          decoration: const InputDecoration(
            hintText: 'Notes',
          ),
        ),
      ],
    );
  }

  /// Builds the container with priority selector and due date field.
  Widget _buildContainerPriorityAndDate() {
    return DefaultContainer(
      activeDivider: true,
      children: [
        PriorityButtons(selectedPriority: _controller.onPrioritySelected),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Due Date',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              DateFormField(
                onDateSelected: _controller.onDateSelected,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the reminder toggle section.
  Widget _buildContainerRemind() {
    return DefaultContainer(
      activeDivider: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Remind Me',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _controller.remindMe,
                  builder: (_, value, __) => CupertinoSwitch(
                    value: value,
                    onChanged: _controller.onRemindChanged,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
