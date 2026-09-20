import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

void main() {
  TaskModel task(
    String id, {
    String title = 'Task',
    String? description,
    bool isCompleted = false,
    bool isFlagged = false,
    DateTime? dueDate,
    TaskCategory category = TaskCategory.personal,
    String? location,
  }) {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      isFlagged: isFlagged,
      dueDate: dueDate,
      category: category,
      location: location,
    );
  }

  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final tomorrow = now.add(const Duration(days: 1));

  group('recortes simples', () {
    final tasks = [
      task('1'),
      task('2', isCompleted: true),
      task('3', isFlagged: true),
      task('4', dueDate: tomorrow),
    ];

    test('pending deixa de fora as concluídas', () {
      expect(tasks.pending.map((t) => t.id), ['1', '3', '4']);
    });

    test('completed traz só as concluídas', () {
      expect(tasks.completed.map((t) => t.id), ['2']);
    });

    test('flagged traz só as sinalizadas', () {
      expect(tasks.flagged.map((t) => t.id), ['3']);
    });

    test('scheduled traz só as que têm data', () {
      expect(tasks.scheduled.map((t) => t.id), ['4']);
    });
  });

  group('forToday', () {
    test('inclui hoje, atrasadas e sem data, mas não as futuras', () {
      final tasks = [
        task('hoje', dueDate: now),
        task('atrasada', dueDate: yesterday),
        task('sem data'),
        task('futura', dueDate: tomorrow),
      ];

      expect(
        tasks.forToday.map((t) => t.id),
        ['hoje', 'atrasada', 'sem data'],
      );
    });
  });

  group('on', () {
    test('compara o dia, ignorando a hora', () {
      final tasks = [
        task('1', dueDate: DateTime(2026, 5, 17, 23, 30)),
        task('2', dueDate: DateTime(2026, 5, 18)),
      ];

      expect(tasks.on(DateTime(2026, 5, 17)).map((t) => t.id), ['1']);
    });

    test('tarefas sem data nunca casam', () {
      expect([task('1')].on(DateTime(2026, 5, 17)), isEmpty);
    });
  });

  group('inCategory', () {
    test('filtra pela lista da tarefa', () {
      final tasks = [
        task('1', category: TaskCategory.work),
        task('2', category: TaskCategory.health),
      ];

      expect(tasks.inCategory(TaskCategory.work).map((t) => t.id), ['1']);
    });
  });

  group('matching', () {
    final tasks = [
      task('titulo', title: 'Comprar pão'),
      task('nota', description: 'Passar na padaria'),
      task('local', location: 'Padaria da esquina'),
      task('lista', category: TaskCategory.shopping),
      task('nada', title: 'Outra coisa'),
    ];

    test('termo vazio não devolve nada', () {
      expect(tasks.matching(''), isEmpty);
      expect(tasks.matching('   '), isEmpty);
    });

    test('procura no título, na nota e no local', () {
      expect(
        tasks.matching('padaria').map((t) => t.id),
        ['nota', 'local'],
      );
    });

    test('ignora maiúsculas', () {
      expect(tasks.matching('COMPRAR').map((t) => t.id), ['titulo']);
    });

    test('encontra pelo nome da lista', () {
      expect(tasks.matching('shopping').map((t) => t.id), ['lista']);
    });
  });
}
