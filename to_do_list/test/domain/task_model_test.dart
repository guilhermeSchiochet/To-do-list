import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

void main() {
  group('TaskModel', () {
    test('normaliza a data de vencimento para o início do dia', () {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        dueDate: DateTime(2026, 5, 17, 14, 32, 8),
      );

      expect(task.dueDate, DateTime(2026, 5, 17));
    });

    test('combina data e hora em dueAt', () {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        dueDate: DateTime(2026, 5, 17),
        dueTime: const TimeOfDay(hour: 9, minute: 5),
      );

      expect(task.dueAt, DateTime(2026, 5, 17, 9, 5));
    });

    test('dueAt é nulo sem data, mesmo com hora', () {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        dueTime: const TimeOfDay(hour: 9, minute: 5),
      );

      expect(task.dueAt, isNull);
    });

    test('sobrevive a uma ida e volta pelo JSON', () {
      final task = TaskModel(
        id: 'abc',
        title: 'Comprar pão',
        description: 'Padaria da esquina',
        isCompleted: true,
        priority: TaskPriority.high,
        dueDate: DateTime(2026, 5, 17),
        dueTime: const TimeOfDay(hour: 18, minute: 30),
        category: TaskCategory.shopping,
        isFlagged: true,
        hasReminder: true,
        location: 'Rua A, 100',
      );

      expect(TaskModel.fromJson(task.toJson()), task);
    });

    group('copyWith', () {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        description: 'Nota',
        dueDate: DateTime(2026, 5, 17),
        dueTime: const TimeOfDay(hour: 9, minute: 0),
        location: 'Casa',
      );

      test('mantém os campos não informados', () {
        expect(task.copyWith(title: 'Outro').description, 'Nota');
        expect(task.copyWith(title: 'Outro').dueDate, DateTime(2026, 5, 17));
      });

      test('limpa campos opcionais pelos sinalizadores', () {
        expect(task.copyWith(clearDescription: true).description, isNull);
        expect(task.copyWith(clearLocation: true).location, isNull);
        expect(task.copyWith(clearDueTime: true).dueTime, isNull);
      });

      test('limpar a data também remove a hora', () {
        final cleared = task.copyWith(clearDueDate: true);

        expect(cleared.dueDate, isNull);
        expect(cleared.dueTime, isNull);
      });
    });

    group('vencimento', () {
      test('isDueToday reconhece o dia de hoje', () {
        final task = TaskModel(id: '1', title: 'Task', dueDate: DateTime.now());

        expect(task.isDueToday, isTrue);
      });

      test('isOverdue aponta tarefas pendentes de dias anteriores', () {
        final task = TaskModel(
          id: '1',
          title: 'Task',
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
        );

        expect(task.isOverdue, isTrue);
      });

      test('uma tarefa concluída nunca está atrasada', () {
        final task = TaskModel(
          id: '1',
          title: 'Task',
          isCompleted: true,
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
        );

        expect(task.isOverdue, isFalse);
      });
    });
  });

  group('TaskCategory.fromStorage', () {
    test('lê o nome do enum', () {
      expect(TaskCategory.fromStorage('travel'), TaskCategory.travel);
    });

    test('aceita os rótulos gravados pelas versões anteriores', () {
      expect(TaskCategory.fromStorage('Shopping'), TaskCategory.shopping);
    });

    test('cai em personal para valores desconhecidos ou nulos', () {
      expect(TaskCategory.fromStorage('inexistente'), TaskCategory.personal);
      expect(TaskCategory.fromStorage(null), TaskCategory.personal);
    });
  });
}
