import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';

/// Reproduz o fluxo real: arrastar remove a tarefa só depois da ida ao
/// banco, e a lista encolhe alguns quadros mais tarde.
/// Reproduces the real flow: a swipe only removes the task after the
/// database round trip, so the list shrinks a few frames later.
class _Host extends StatefulWidget {
  final List<TaskModel> initial;
  final List<String> deleted;

  const _Host({required this.initial, required this.deleted});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late List<TaskModel> _tasks = List.of(widget.initial);

  Future<void> _delete(TaskModel task) async {
    widget.deleted.add(task.id);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (mounted) {
      setState(() => _tasks = _tasks.where((t) => t.id != task.id).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: TaskList(
          tasks: _tasks,
          actions: TaskActions(
            toggleCompleted: (_) {},
            toggleFlag: (_) {},
            delete: _delete,
            edit: (_) {},
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('arrastar uma linha não derruba as seguintes', (tester) async {
    final deleted = <String>[];
    final tasks = [
      for (var i = 1; i <= 8; i++) TaskModel(id: '$i', title: 'Task $i'),
    ];

    await tester.pumpWidget(_Host(initial: tasks, deleted: deleted));
    await tester.pumpAndSettle();

    await tester.fling(find.text('Task 1'), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    // Deixa a "ida ao banco" terminar e a lista encolher.
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();

    expect(deleted, ['1']);
    expect(find.text('Task 1'), findsNothing);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 8'), findsOneWidget);
  });

  testWidgets('excluir várias em sequência remove só as arrastadas',
      (tester) async {
    final deleted = <String>[];
    final tasks = [
      for (var i = 1; i <= 8; i++) TaskModel(id: '$i', title: 'Task $i'),
    ];

    await tester.pumpWidget(_Host(initial: tasks, deleted: deleted));
    await tester.pumpAndSettle();

    await tester.fling(find.text('Task 1'), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();

    await tester.fling(find.text('Task 2'), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();

    expect(deleted, ['1', '2']);
    expect(find.text('Task 3'), findsOneWidget);
  });
}
