import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/calendar_controller.dart';

void main() {
  // Uma quinta-feira, para que a grade tenha dias de sobra nas duas bordas.
  final reference = DateTime(2026, 5, 14);

  late CalendarController controller;

  setUp(() => controller = CalendarController(today: reference));
  tearDown(() => controller.dispose());

  List<CalendarDay> flat(List<List<CalendarDay>> grid) =>
      [for (final week in grid) ...week];

  test('começa no mês do dia de referência, com ele selecionado', () {
    expect(controller.state.value.mode, CalendarMode.month);
    expect(controller.state.value.selectedDate, reference);
    expect(controller.periodLabel, 'May 2026');
  });

  group('grade do mês', () {
    test('sempre tem semanas completas de sete dias', () {
      final grid = controller.grid(const []);

      expect(grid.every((week) => week.length == 7), isTrue);
    });

    test('começa num domingo', () {
      expect(controller.grid(const []).first.first.date.weekday,
          DateTime.sunday);
    });

    test('cobre o mês inteiro sem pular nem repetir dias', () {
      final days = flat(controller.grid(const []))
          .where((day) => !day.isOutsideMonth)
          .map((day) => day.date.day)
          .toList();

      expect(days, List.generate(31, (i) => i + 1));
    });

    test('marca como fora do mês os dias que só fecham a semana', () {
      final outside = flat(controller.grid(const []))
          .where((day) => day.isOutsideMonth)
          .toList();

      expect(outside.every((day) => day.date.month != 5), isTrue);
    });

    test('leva as tarefas para o dia certo', () {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        dueDate: DateTime(2026, 5, 20),
      );

      final day = flat(controller.grid([task]))
          .firstWhere((day) => day.date.day == 20 && !day.isOutsideMonth);

      expect(day.tasks.single.id, '1');
    });
  });

  group('modo semana', () {
    test('mostra uma única semana com o dia selecionado dentro', () {
      controller.setMode(CalendarMode.week);
      final grid = controller.grid(const []);

      expect(grid, hasLength(1));
      expect(
        grid.single.map((day) => day.date),
        contains(reference),
      );
    });

    test('avançar anda sete dias', () {
      controller.setMode(CalendarMode.week);
      controller.move(1);

      expect(
        controller.grid(const []).single.first.date,
        DateTime(2026, 5, 17),
      );
    });
  });

  group('navegação', () {
    test('avançar e voltar um mês retorna ao ponto de partida', () {
      controller.move(1);
      expect(controller.periodLabel, 'June 2026');

      controller.move(-1);
      expect(controller.periodLabel, 'May 2026');
    });

    test('navegar não muda o dia selecionado', () {
      controller.move(1);

      expect(controller.state.value.selectedDate, reference);
    });

    test('registra o sentido para a transição deslizar certo', () {
      controller.move(1);
      expect(controller.state.value.movingForward, isTrue);

      controller.move(-1);
      expect(controller.state.value.movingForward, isFalse);
    });

    test('selecionar um dia leva o período junto', () {
      controller.select(DateTime(2026, 7, 4));

      expect(controller.periodLabel, 'July 2026');
      expect(controller.selectedDayLabel, 'Saturday, Jul 4');
    });

    test('jumpToToday volta para hoje', () {
      controller.select(DateTime(2026, 7, 4));
      controller.jumpToToday();

      expect(
        controller.state.value.selectedDate,
        DateUtils.dateOnly(DateTime.now()),
      );
    });
  });

  test('selectedTasks traz só as do dia escolhido', () {
    final tasks = [
      TaskModel(id: '1', title: 'A', dueDate: reference),
      TaskModel(id: '2', title: 'B', dueDate: DateTime(2026, 5, 15)),
      TaskModel(id: '3', title: 'C'),
    ];

    expect(controller.selectedTasks(tasks).map((t) => t.id), ['1']);
  });
}
