import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:to_do_list/src/config/layout/app_layout.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/widgets/empty_state.dart';
import 'package:to_do_list/src/presentation/widgets/my_button_bar.dart';
import 'package:to_do_list/src/presentation/widgets/task_tile.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

/// As ações que uma tarefa aceita, montadas uma vez na tela principal e
/// repassadas a todas as listas.
/// The actions a task accepts, built once in the main screen and handed down
/// to every list.
@immutable
class TaskActions {
  final ValueChanged<TaskModel> toggleCompleted;
  final ValueChanged<TaskModel> toggleFlag;
  final ValueChanged<TaskModel> delete;
  final ValueChanged<TaskModel> edit;

  const TaskActions({
    required this.toggleCompleted,
    required this.toggleFlag,
    required this.delete,
    required this.edit,
  });
}

/// Lista de tarefas com as concluídas agrupadas no fim, como nos mockups.
/// Task list with completed items grouped at the bottom, as in the mockups.
class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final TaskActions actions;

  /// Sliver exibido acima da lista, como o cabeçalho da tela Today.
  final Widget? header;

  /// Exibe a hora no lugar da nota, usado pelo calendário.
  final bool showTime;

  /// Mensagem exibida quando não há tarefas.
  final Widget? emptyState;

  /// Espaço extra no fim. Quando não informado, é o suficiente para o
  /// último item não terminar embaixo da barra inferior — e some quando a
  /// navegação está na lateral, que não cobre a lista.
  final double? bottomPadding;

  const TaskList({
    super.key,
    required this.tasks,
    required this.actions,
    this.header,
    this.showTime = false,
    this.emptyState,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final pending = tasks.pending;
    final completed = tasks.completed;
    final endInset = bottomPadding ??
        (context.isExpandedLayout ? 24 : MyBottomBar.contentInset);

    return CustomScrollView(
      slivers: [
        if (header != null) header!,
        if (tasks.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: emptyState ??
                EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  title: strings.emptyDayTitle,
                  subtitle: strings.emptyDaySubtitle,
                ),
          )
        else ...[
          _sliverFor(pending),
          if (completed.isNotEmpty) ...[
            SliverToBoxAdapter(child: _CompletedHeader()),
            _sliverFor(completed, indexOffset: pending.length),
          ],
        ],
        SliverToBoxAdapter(child: SizedBox(height: endInset)),
      ],
    );
  }

  /// As tarefas entram escalonadas, mas só as primeiras: atrasar itens muito
  /// abaixo deixaria a lista parecendo lenta.
  Widget _sliverFor(List<TaskModel> items, {int indexOffset = 0}) {
    return SliverList.builder(
      itemCount: items.length,
      // A chave precisa estar no widget mais externo devolvido aqui: é ela
      // que o sliver usa para casar cada tarefa com seu elemento. Sem isso
      // o casamento é por posição, e ao excluir uma linha a de baixo herda
      // o estado da que saiu — inclusive o de já ter sido arrastada.
      findChildIndexCallback: (key) {
        final id = (key as ValueKey<String>).value;
        final index = items.indexWhere((task) => task.id == id);
        return index == -1 ? null : index;
      },
      itemBuilder: (context, index) {
        final task = items[index];
        final delay = ((index + indexOffset).clamp(0, 8) * 40).ms;

        return KeyedSubtree(
          key: ValueKey<String>(task.id),
          child: TaskTile(
            task: task,
            showTime: showTime,
            onToggleCompleted: () => actions.toggleCompleted(task),
            onToggleFlag: () => actions.toggleFlag(task),
            onDelete: () => actions.delete(task),
            onTap: () => actions.edit(task),
          ).animate().fadeIn(duration: 280.ms, delay: delay).slideY(
                begin: 0.1,
                end: 0,
                duration: 280.ms,
                delay: delay,
                curve: Curves.easeOutQuad,
              ),
        );
      },
    );
  }
}

/// Título da seção de tarefas concluídas.
class _CompletedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 10),
      child: Text(
        strings.completedSection,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: context.colors.secondaryLabel,
        ),
      ),
    );
  }
}
