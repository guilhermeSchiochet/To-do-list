import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/today_controller.dart';
import 'package:to_do_list/src/presentation/widgets/empty_state.dart';
import 'package:to_do_list/src/presentation/widgets/large_title_header.dart';
import 'package:to_do_list/src/presentation/widgets/profile_avatar.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// A tela inicial: o que precisa de atenção hoje.
/// The home screen: what needs attention today.
class TodayView extends StatelessWidget {
  final List<TaskModel> tasks;
  final TaskActions actions;
  final VoidCallback onSearchPressed;

  /// Chamado ao tocar no avatar, que leva às preferências.
  final VoidCallback onProfilePressed;

  const TodayView({
    super.key,
    required this.tasks,
    required this.actions,
    required this.onSearchPressed,
    required this.onProfilePressed,
  });

  static const TodayController _controller = TodayController();

  @override
  Widget build(BuildContext context) {
    final visible = _controller.visibleTasks(tasks);

    return TaskList(
      tasks: visible,
      actions: actions,
      emptyState: EmptyState(
        icon: Icons.wb_sunny_outlined,
        title: strings.emptyTodayTitle,
        subtitle: strings.emptyTodaySubtitle,
      ),
      header: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LargeTitleHeader(
              eyebrow: _controller.headerDate(),
              title: strings.todayTitle,
              actions: [
                HeaderIconButton(
                  icon: Icons.search_rounded,
                  tooltip: strings.searchTitle,
                  onPressed: onSearchPressed,
                ),
                const SizedBox(width: 4),
                ProfileAvatar(onTap: onProfilePressed),
                const SizedBox(width: 8),
              ],
            ),
            _ProgressCounter(
              completed: _controller.completedCount(visible),
              total: visible.length,
            ),
          ],
        ),
      ),
    );
  }
}

/// O contador grande de tarefas concluídas do topo da tela.
class _ProgressCounter extends StatelessWidget {
  final int completed;
  final int total;

  const _ProgressCounter({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // O número anima ao concluir uma tarefa, dando retorno à ação.
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: completed.toDouble()),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => Text(
              value.round().toString(),
              style: const TextStyle(
                fontSize: 48,
                height: 1,
                fontWeight: FontWeight.w300,
                color: AppPalette.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            strings.tasksCompleted(total),
            style: TextStyle(
              fontSize: 17,
              color: context.colors.secondaryLabel,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}
