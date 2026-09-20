import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Uma linha da lista de tarefas.
/// A single row in a task list.
///
/// Arrastar para a esquerda exclui, para a direita sinaliza, e o toque abre
/// o editor. É o mesmo componente em Today, Calendar, Lists e Search.
class TaskTile extends StatelessWidget {
  final TaskModel task;

  /// Chamado ao tocar no círculo à esquerda.
  final VoidCallback onToggleCompleted;

  /// Chamado ao arrastar a tarefa para a direita.
  final VoidCallback onToggleFlag;

  /// Chamado ao arrastar a tarefa para a esquerda.
  final VoidCallback onDelete;

  /// Chamado ao tocar na tarefa.
  final VoidCallback onTap;

  /// Mostra a hora de vencimento no lugar da descrição, como no calendário.
  final bool showTime;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onToggleFlag,
    required this.onDelete,
    required this.onTap,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dismissible(
      key: ValueKey<String>(task.id),
      background: _SwipeBackground(
        color: AppPalette.orange,
        icon: task.isFlagged ? Icons.flag_outlined : Icons.flag_rounded,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: const _SwipeBackground(
        color: AppPalette.red,
        icon: Icons.delete_rounded,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        // Sinalizar altera a tarefa no lugar, então a linha não sai da lista.
        if (direction == DismissDirection.startToEnd) {
          HapticFeedback.lightImpact();
          onToggleFlag();
          return false;
        }
        return true;
      },
      onDismissed: (_) => onDelete(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: task.isCompleted ? 0.4 : 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.separator, width: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    _Checkbox(
                      isCompleted: task.isCompleted,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onToggleCompleted();
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _content(context, colors)),
                    if (task.isFlagged) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.flag_rounded,
                        size: 16,
                        color: AppPalette.orange,
                      ),
                    ],
                    if (!task.isCompleted) ...[
                      const SizedBox(width: 12),
                      _PriorityDot(color: task.priority.color),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, AppColors colors) {
    final subtitle = _subtitle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: colors.label,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: colors.label,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              height: 1.2,
              color: task.isOverdue ? AppPalette.red : colors.secondaryLabel,
            ),
          ),
        ],
      ],
    );
  }

  /// A hora tem prioridade no calendário; nas demais telas mostra a nota.
  String? _subtitle() {
    if (showTime && task.dueTime != null) {
      return DateFormat.jm().format(task.dueAt!);
    }
    final description = task.description?.trim();
    if (description != null && description.isNotEmpty) return description;
    if (task.dueTime != null) return DateFormat.jm().format(task.dueAt!);
    return null;
  }
}

/// Círculo de conclusão, com a marca de verificação animada.
class _Checkbox extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const _Checkbox({required this.isCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? AppPalette.primary : Colors.transparent,
          border: Border.all(color: AppPalette.primary, width: 2),
        ),
        child: isCompleted
            ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                .animate()
                .scale(duration: 200.ms, curve: Curves.easeOutBack)
            : null,
      ),
    );
  }
}

/// Ponto colorido que indica a prioridade, com o brilho suave do mockup.
class _PriorityDot extends StatelessWidget {
  final Color color;

  const _PriorityDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// Fundo revelado ao arrastar a tarefa.
class _SwipeBackground extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Alignment alignment;

  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
