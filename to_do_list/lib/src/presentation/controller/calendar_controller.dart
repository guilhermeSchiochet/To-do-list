import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

/// Como o calendário está sendo exibido.
/// How the calendar is being displayed.
enum CalendarMode { month, week }

/// O período visível e o dia escolhido.
/// The visible period and the chosen day.
@immutable
class CalendarState {
  final CalendarMode mode;

  /// Dia cujas tarefas aparecem na lista de baixo.
  final DateTime selectedDate;

  /// Qualquer dia dentro do período desenhado, usado para saber qual mês
  /// ou semana montar.
  final DateTime visibleDate;

  /// Se a última navegação foi para frente, para a transição deslizar no
  /// sentido certo.
  final bool movingForward;

  const CalendarState({
    required this.mode,
    required this.selectedDate,
    required this.visibleDate,
    required this.movingForward,
  });

  CalendarState copyWith({
    CalendarMode? mode,
    DateTime? selectedDate,
    DateTime? visibleDate,
    bool? movingForward,
  }) {
    return CalendarState(
      mode: mode ?? this.mode,
      selectedDate: selectedDate ?? this.selectedDate,
      visibleDate: visibleDate ?? this.visibleDate,
      movingForward: movingForward ?? this.movingForward,
    );
  }
}

/// Um dia dentro da grade do calendário, já com tudo que a célula precisa.
/// A day inside the calendar grid, with everything the cell needs.
@immutable
class CalendarDay {
  final DateTime date;
  final bool isSelected;
  final bool isToday;

  /// Dia de outro mês, mostrado apagado para fechar a semana.
  final bool isOutsideMonth;

  /// Tarefas do dia, que viram os pontinhos abaixo do número.
  final List<TaskModel> tasks;

  const CalendarDay({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isOutsideMonth,
    required this.tasks,
  });
}

/// Navegação e montagem da grade do calendário.
/// Calendar navigation and grid assembly.
class CalendarController {
  CalendarController({DateTime? today}) {
    final start = DateUtils.dateOnly(today ?? DateTime.now());
    _state = ValueNotifier<CalendarState>(
      CalendarState(
        mode: CalendarMode.month,
        selectedDate: start,
        visibleDate: start,
        movingForward: true,
      ),
    );
  }

  late final ValueNotifier<CalendarState> _state;

  ValueListenable<CalendarState> get state => _state;

  /// Coluna da semana em que o dia cai, com domingo em zero.
  static int columnOf(DateTime date) => date.weekday % 7;

  /// Iniciais dos dias da semana, vindas do `intl` para acompanharem o
  /// idioma em vez de ficarem fixas no código.
  List<String> get weekdayLabels => DateFormat().dateSymbols.NARROWWEEKDAYS;

  /// Título do período, como "September 2026".
  String get periodLabel => DateFormat.yMMMM().format(_state.value.visibleDate);

  /// Título da lista de baixo, como "Sunday, Sep 20".
  String get selectedDayLabel =>
      DateFormat('EEEE, MMM d').format(_state.value.selectedDate);

  /// Identidade do período desenhado, usada como chave da transição.
  String get periodKey => '${_state.value.mode}-$_gridStart';

  /// Primeiro dia da grade: o domingo que abre a primeira semana exibida.
  DateTime get _gridStart {
    final current = _state.value;
    if (current.mode == CalendarMode.week) {
      return current.visibleDate
          .subtract(Duration(days: columnOf(current.visibleDate)));
    }
    final firstOfMonth =
        DateTime(current.visibleDate.year, current.visibleDate.month);
    return firstOfMonth.subtract(Duration(days: columnOf(firstOfMonth)));
  }

  int get _rowCount {
    final current = _state.value;
    if (current.mode == CalendarMode.week) return 1;

    final daysInMonth = DateUtils.getDaysInMonth(
      current.visibleDate.year,
      current.visibleDate.month,
    );
    final firstOfMonth =
        DateTime(current.visibleDate.year, current.visibleDate.month);
    return ((daysInMonth + columnOf(firstOfMonth)) / 7).ceil();
  }

  /// A grade pronta, linha por linha, já resolvida contra as tarefas.
  List<List<CalendarDay>> grid(List<TaskModel> tasks) {
    final current = _state.value;
    final start = _gridStart;
    final today = DateTime.now();

    return [
      for (var row = 0; row < _rowCount; row++)
        [
          for (var column = 0; column < 7; column++)
            _dayAt(
              // Somar dias a partir do início evita o deslocamento que
              // `Duration` causaria ao cruzar uma mudança de horário.
              DateUtils.addDaysToDate(start, row * 7 + column),
              current,
              today,
              tasks,
            ),
        ],
    ];
  }

  CalendarDay _dayAt(
    DateTime date,
    CalendarState current,
    DateTime today,
    List<TaskModel> tasks,
  ) {
    return CalendarDay(
      date: date,
      isSelected: DateUtils.isSameDay(date, current.selectedDate),
      isToday: DateUtils.isSameDay(date, today),
      isOutsideMonth: current.mode == CalendarMode.month &&
          date.month != current.visibleDate.month,
      tasks: tasks.on(date),
    );
  }

  /// Tarefas do dia selecionado.
  List<TaskModel> selectedTasks(List<TaskModel> tasks) =>
      tasks.on(_state.value.selectedDate);

  void setMode(CalendarMode mode) {
    _state.value = _state.value.copyWith(
      mode: mode,
      // Ao trocar de modo, o período volta para o dia escolhido.
      visibleDate: _state.value.selectedDate,
    );
  }

  /// Avança ([direction] positivo) ou volta um mês ou uma semana.
  void move(int direction) {
    final current = _state.value;
    _state.value = current.copyWith(
      movingForward: direction > 0,
      visibleDate: current.mode == CalendarMode.week
          ? DateUtils.addDaysToDate(current.visibleDate, 7 * direction)
          : DateTime(
              current.visibleDate.year,
              current.visibleDate.month + direction,
            ),
    );
  }

  void select(DateTime date) {
    final current = _state.value;
    _state.value = current.copyWith(
      movingForward: date.isAfter(current.selectedDate),
      selectedDate: date,
      visibleDate: date,
    );
  }

  /// Volta para hoje. Sem efeito se hoje já estiver selecionado.
  void jumpToToday() {
    final today = DateUtils.dateOnly(DateTime.now());
    if (today == _state.value.selectedDate) return;
    select(today);
  }

  void dispose() => _state.dispose();
}
