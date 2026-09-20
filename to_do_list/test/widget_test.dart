import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

void main() {
  /// Registra qual ação foi disparada por cada interação.
  late List<String> events;

  setUp(() => events = []);

  TaskActions actions() => TaskActions(
        toggleCompleted: (task) => events.add('completed:${task.id}'),
        toggleFlag: (task) => events.add('flagged:${task.id}'),
        delete: (task) => events.add('deleted:${task.id}'),
        edit: (task) => events.add('edited:${task.id}'),
      );

  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: child),
      );

  TaskModel task(
    String id, {
    String? title,
    bool isCompleted = false,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id,
      title: title ?? 'Task $id',
      isCompleted: isCompleted,
      priority: TaskPriority.medium,
      dueDate: dueDate,
    );
  }

  group('TaskList', () {
    testWidgets('separa pendentes das concluídas', (tester) async {
      await tester.pumpWidget(wrap(TaskList(
        tasks: [task('1'), task('2', isCompleted: true)],
        actions: actions(),
      )));
      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text(strings.completedSection), findsOneWidget);
    });

    testWidgets('esconde a seção de concluídas quando não há nenhuma',
        (tester) async {
      await tester.pumpWidget(wrap(TaskList(
        tasks: [task('1')],
        actions: actions(),
      )));
      await tester.pumpAndSettle();

      expect(find.text(strings.completedSection), findsNothing);
    });

    testWidgets('mostra o estado vazio sem tarefas', (tester) async {
      await tester.pumpWidget(wrap(TaskList(tasks: const [], actions: actions())));
      await tester.pumpAndSettle();

      expect(find.text(strings.emptyDayTitle), findsOneWidget);
    });

    testWidgets('tocar na tarefa abre a edição', (tester) async {
      await tester.pumpWidget(wrap(TaskList(
        tasks: [task('1')],
        actions: actions(),
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Task 1'));

      expect(events, ['edited:1']);
    });

    testWidgets('arrastar para a esquerda exclui', (tester) async {
      await tester.pumpWidget(wrap(TaskList(
        tasks: [task('1')],
        actions: actions(),
      )));
      await tester.pumpAndSettle();

      await tester.fling(find.text('Task 1'), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(events, ['deleted:1']);
    });

    testWidgets('arrastar uma linha exclui só aquela tarefa', (tester) async {
      // A lista não encolhe na mesma hora: a exclusão passa pelo banco antes
      // de voltar para a UI. Nesse intervalo o slot não pode disparar de novo.
      await tester.pumpWidget(wrap(TaskList(
        tasks: [for (var i = 1; i <= 8; i++) task('$i')],
        actions: actions(),
      )));
      await tester.pumpAndSettle();

      await tester.fling(find.text('Task 1'), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(events, ['deleted:1']);
    });

    testWidgets('arrastar para a direita sinaliza sem remover a linha',
        (tester) async {
      await tester.pumpWidget(wrap(TaskList(
        tasks: [task('1')],
        actions: actions(),
      )));
      await tester.pumpAndSettle();

      await tester.fling(find.text('Task 1'), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();

      expect(events, ['flagged:1']);
      expect(find.text('Task 1'), findsOneWidget);
    });
  });
}
