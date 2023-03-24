import 'package:flutter/material.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/domain/useCases/add_use_case.dart';
import 'package:to_do_list/presentation/widgets/priority_button.dart';
import 'package:to_do_list/presentation/widgets/text_form_field_builder.dart';

class AddTaskPage extends StatefulWidget {
  final AddTaskUseCase addTaskUseCase;

  const AddTaskPage({Key? key, required this.addTaskUseCase}) : super(key: key);

  @override
  createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.low;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Tarefa'),
      ),
      body: SingleChildScrollView(
        child: _buildBody(context)
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 16.0),
      child: _buildSaveButton(),
    ),
    );
  }

  /// Constrói o corpo da página.
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          TextFormFieldBuilder(
            title: 'Título',
            controller: _titleController,
          ),
            const SizedBox(height: 16),
          TextFormFieldBuilder(
            title: 'Descrição',
            maxLines: 5,
            controller: _descriptionController,
          ),
            const SizedBox(height: 16),
            _buildPrioritySection(),
        ],
      ),
    );
  }

  /// Constrói a seção de prioridade da tarefa.
  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Prioridade'),
        const SizedBox(height: 8),
        Row(
          children: _buildPriorityButtons(),
        ),
      ],
    );
  }

  /// Constrói a lista de botões de prioridade.
  List<Widget> _buildPriorityButtons() {
    final buttons = <Widget>[];

    for (final priority in TaskPriority.values) {
      buttons.add(
        Expanded(
          flex: 1,
          child: _buildPriorityButton(priority),
        ),
      );
      if (priority != TaskPriority.high) {
        buttons.add(const SizedBox(width: 8));
      }
    }
    return buttons;
  }

  /// Constrói um botão de prioridade.
  PriorityButton _buildPriorityButton(TaskPriority priority) {
    return PriorityButton(
      priority: priority,
      isSelected: _selectedPriority == priority,
      onTap: (selectedPriority) => setState(() => _selectedPriority = selectedPriority),
    );
  }

  /// Constrói o botão de salvar a tarefa.
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

  /// Salva a tarefa e retorna para a tela anterior.
  void _saveTask(BuildContext context) {

    final title = _titleController.text;
    final description = _descriptionController.text;

    final task = TaskModel(
      id: UniqueKey().toString(),
      title: title,
      description: description,
      priority: _selectedPriority,
    );

    try {
      widget.addTaskUseCase.call(task);
    } catch (e) {
      throw 'Erro add';
    } 

    Navigator.pop(context, task);
    
  }
}