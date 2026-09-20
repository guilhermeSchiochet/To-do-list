import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/calendar_controller.dart';
import 'package:to_do_list/src/presentation/widgets/segmented_control.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Calendário com as tarefas do dia selecionado abaixo.
/// Calendar with the selected day's tasks below it.
class CalendarView extends StatefulWidget {
  final List<TaskModel> tasks;
  final TaskActions actions;

  /// Chamado ao tocar no botão de adicionar do dia selecionado.
  final ValueChanged<DateTime> onAddTask;

  final VoidCallback onSearchPressed;

  const CalendarView({
    super.key,
    required this.tasks,
    required this.actions,
    required this.onAddTask,
    required this.onSearchPressed,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final CalendarController _controller = CalendarController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(DateTime date) {
    HapticFeedback.selectionClick();
    _controller.select(date);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CalendarState>(
      valueListenable: _controller.state,
      builder: (context, state, _) {
        final colors = context.colors;

        return Column(
          children: [
            _header(colors),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: SegmentedControl<CalendarMode>(
                expand: true,
                value: state.mode,
                segments: {
                  CalendarMode.month: strings.calendarMonth,
                  CalendarMode.week: strings.calendarWeek,
                },
                onChanged: _controller.setMode,
              ),
            ),
            _weekdayLabels(colors),
            _swipeableGrid(colors, state),
            const SizedBox(height: 12),
            Divider(height: 0.5, thickness: 0.5, color: colors.separator),
            _selectedDayHeader(colors, state),
            Expanded(
              child: TaskList(
                key: ValueKey<DateTime>(state.selectedDate),
                tasks: _controller.selectedTasks(widget.tasks),
                actions: widget.actions,
                showTime: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _header(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _controller.move(-1),
            icon: const Icon(Icons.chevron_left_rounded, size: 30),
            color: AppPalette.primary,
          ),
          Expanded(
            child: GestureDetector(
              onTap: _controller.jumpToToday,
              behavior: HitTestBehavior.opaque,
              child: Text(
                _controller.periodLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colors.label,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _controller.move(1),
            icon: const Icon(Icons.chevron_right_rounded, size: 30),
            color: AppPalette.primary,
          ),
          IconButton(
            onPressed: widget.onSearchPressed,
            tooltip: strings.searchTitle,
            icon: const Icon(Icons.search_rounded, size: 24),
            color: AppPalette.primary,
          ),
        ],
      ),
    );
  }

  Widget _weekdayLabels(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (final label in _controller.weekdayLabels)
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: colors.secondaryLabel,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _swipeableGrid(AppColors colors, CalendarState state) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity != 0) _controller.move(velocity < 0 ? 1 : -1);
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(state.movingForward ? 0.12 : -0.12, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey<String>(_controller.periodKey),
            child: _grid(colors),
          ),
        ),
      ),
    );
  }

  Widget _grid(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final week in _controller.grid(widget.tasks))
            Row(
              children: [
                for (final day in week)
                  Expanded(
                    child: _DayCell(
                      day: day,
                      colors: colors,
                      onTap: () => _select(day.date),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _selectedDayHeader(AppColors colors, CalendarState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _controller.selectedDayLabel,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
                color: colors.label,
              ),
            ),
          ),
          IconButton(
            onPressed: () => widget.onAddTask(state.selectedDate),
            tooltip: strings.newTaskTitle,
            style: IconButton.styleFrom(
              backgroundColor: AppPalette.primary.withValues(alpha: 0.12),
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(
              Icons.add_rounded,
              size: 20,
              color: AppPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Um dia da grade: o número e os pontinhos das tarefas.
class _DayCell extends StatelessWidget {
  final CalendarDay day;
  final AppColors colors;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.colors,
    required this.onTap,
  });

  Color get _textColor {
    if (day.isSelected) return Colors.white;
    if (day.isOutsideMonth) return colors.tertiaryLabel;
    if (day.isToday) return AppPalette.primary;
    return colors.label;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: day.isSelected ? AppPalette.primary : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: day.isSelected
                    ? [
                        BoxShadow(
                          color: AppPalette.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                '${day.date.day}',
                style: TextStyle(
                  fontSize: 17,
                  color: _textColor,
                  fontWeight: day.isSelected || day.isToday
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(height: 4, child: _dots()),
          ],
        ),
      ),
    );
  }

  /// Até três pontinhos, coloridos pela prioridade. O dia selecionado não
  /// os mostra: o círculo cheio já chamaria atenção demais.
  Widget? _dots() {
    if (day.tasks.isEmpty || day.isSelected) return null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final task in day.tasks.take(3))
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted
                  ? colors.tertiaryLabel
                  : task.priority.color,
            ),
          ),
      ],
    );
  }
}
