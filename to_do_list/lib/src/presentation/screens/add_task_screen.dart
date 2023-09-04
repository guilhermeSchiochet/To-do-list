import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/presentation/widgets/priority_button.dart';
import 'package:to_do_list/src/presentation/widgets/text_form_field_builder.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class AddTaskScreen extends StatefulWidget {

  final bool readOnly;
  final TaskModel? task;
  final AddTaskUseCase? addTaskUseCase;

  const AddTaskScreen({
    Key? key,
    this.task,
    this.addTaskUseCase,
    this.readOnly = false,
  }) : super(key: key);

  @override
  createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  late TaskPriority _selectedPriority;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    initFunctions();
    super.initState();
  }

  // Inicializa controlers
  void initFunctions() {
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedPriority = widget.task?.priority ?? TaskPriority.low;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.readOnly ? 'Detalhes da Tarefa' : 'Adicionar Tarefa'
        ),
      ),
      body: SingleChildScrollView(
        child: _buildBody(context)
      ),
      floatingActionButton: widget.readOnly ? null : _buildSaveButton(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Column(
            children: _campos,
          ),
          const SizedBox(height: 16),
          _buildPrioritySection(),
        ],
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioridade',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _buildPriorityButtons(),
        ),
      ],
    );
  }

  List<Widget> _buildPriorityButtons() {
    return TaskPriority.values.map((priority) => Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: PriorityButton(
          priority: priority,
          isSelected: _selectedPriority == priority,
          onTap: widget.readOnly ? null : (selectedPriority) => setState(() => _selectedPriority = selectedPriority),
        ),
      ),
    )).toList();
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => _saveTask(context),
        child: const Text('Salvar'),
      ),
    );
  }

  List<Widget> get _campos => [
    TextFormFieldBuilder(
      title: 'Título',
      controller: _titleController,
      readOnly: widget.readOnly,
    ),
    const SizedBox(height: 16),
    TextFormFieldBuilder(
      title: 'Descrição',
      maxLines: 5,
      controller: _descriptionController,
      readOnly: widget.readOnly,
    ),
  ];

  // Save file
  void _saveTask(BuildContext context) {
    final task = TaskModel(
      id: UniqueKey().toString(),
      priority: _selectedPriority,
      title: _titleController.text,
      description: _descriptionController.text,
    );

    try {
      widget.addTaskUseCase?.call(task);
    } catch (e) {
      throw 'Erro add';
    }

    Navigator.pop(context, task);
  }
}
