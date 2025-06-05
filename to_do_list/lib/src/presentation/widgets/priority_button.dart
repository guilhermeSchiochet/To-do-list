import 'package:flutter/material.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Botão de prioridade para a tela de adição de tarefas.
class PriorityButton extends StatefulWidget {
  /// A prioridade do botão.
  final TaskPriority priority;

  /// Indica se o botão está selecionado ou não.
  final bool isSelected;

  /// Função chamada quando o botão é pressionado.
  final void Function(TaskPriority)? onTap;

  /// Cria um novo botão de prioridade.
  const PriorityButton({
    super.key,
    required this.priority,
    this.isSelected = false,
    this.onTap,
  });

  @override
  createState() => _PriorityButtonState();
}

/// Estado do widget PriorityButton.
class _PriorityButtonState extends State<PriorityButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: _buildContainer(),
    );
  }

  /// Constrói o container do botão de prioridade.
  AnimatedContainer _buildContainer() {
    return AnimatedContainer(
      width: 80,
      height: widget.isSelected ? 120 : 100,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.isSelected ? widget.priority.color.withValues(alpha: 1.0) : widget.priority.color.withValues(alpha: 0.8),
      ),
      child: _buildContent(),
    );
  }

  /// Retorna o conteúdo do botão de prioridade.
  Column _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.priority.icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          widget.priority.toShortString(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: widget.isSelected ? 1.0 : 0.8),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  /// Manipula o evento de toque no botão de prioridade.
  void _handleTap() {
    widget.onTap?.call(widget.priority);
  }
}
