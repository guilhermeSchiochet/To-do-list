import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/data/services/notification_service.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/task_editor_controller.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Concede ou nega a permissão sem tocar no plugin nativo.
class _FakeNotificationService extends NotificationService {
  _FakeNotificationService({required this.granted});

  final bool granted;

  @override
  bool get isSupported => true;

  @override
  bool get hasPermission => false;

  @override
  Future<bool> requestPermission() async => granted;
}

void main() {
  TaskEditorController editorFor({
    TaskModel? task,
    DateTime? initialDate,
    bool permissionGranted = true,
  }) {
    return TaskEditorController(
      task: task,
      initialDate: initialDate,
      notificationService:
          _FakeNotificationService(granted: permissionGranted),
    );
  }

  group('tarefa nova', () {
    test('não deixa salvar sem título', () {
      final controller = editorFor();

      expect(controller.canSave.value, isFalse);
      expect(controller.buildTask(), isNull);

      controller.dispose();
    });

    test('libera o salvar assim que o título tem conteúdo', () {
      final controller = editorFor();

      controller.title.text = 'Comprar pão';

      expect(controller.canSave.value, isTrue);
      controller.dispose();
    });

    test('título só com espaços não conta', () {
      final controller = editorFor();

      controller.title.text = '   ';

      expect(controller.canSave.value, isFalse);
      controller.dispose();
    });

    test('abre com o teclado no título', () {
      final controller = editorFor();

      expect(controller.autofocusTitle, isTrue);
      controller.dispose();
    });

    test('aproveita a data que o calendário passou', () {
      final controller = editorFor(initialDate: DateTime(2026, 5, 17));

      expect(controller.draft.value.dueDate, DateTime(2026, 5, 17));
      controller.dispose();
    });

    test('monta a tarefa com o que foi preenchido', () {
      final controller = editorFor();
      controller.title.text = '  Comprar pão  ';
      controller.notes.text = '  Padaria  ';
      controller.setPriority(TaskPriority.high);
      controller.setCategory(TaskCategory.shopping);
      controller.setDueDate(DateTime(2026, 5, 17));
      controller.setDueTime(const TimeOfDay(hour: 8, minute: 30));
      controller.setFlagged(true);
      controller.setLocation(' Rua A ');

      final task = controller.buildTask()!;

      expect(task.title, 'Comprar pão');
      expect(task.description, 'Padaria');
      expect(task.priority, TaskPriority.high);
      expect(task.category, TaskCategory.shopping);
      expect(task.dueDate, DateTime(2026, 5, 17));
      expect(task.dueTime, const TimeOfDay(hour: 8, minute: 30));
      expect(task.isFlagged, isTrue);
      expect(task.location, 'Rua A');

      controller.dispose();
    });
  });

  group('edição', () {
    final existing = TaskModel(
      id: 'abc',
      title: 'Original',
      description: 'Nota',
      priority: TaskPriority.low,
      dueDate: DateTime(2026, 5, 17),
      dueTime: const TimeOfDay(hour: 9, minute: 0),
      category: TaskCategory.work,
      location: 'Casa',
    );

    test('carrega os campos da tarefa', () {
      final controller = editorFor(task: existing);

      expect(controller.isEditing, isTrue);
      expect(controller.autofocusTitle, isFalse);
      expect(controller.title.text, 'Original');
      expect(controller.notes.text, 'Nota');
      expect(controller.draft.value.category, TaskCategory.work);
      expect(controller.draft.value.location, 'Casa');

      controller.dispose();
    });

    test('mantém o id ao salvar', () {
      final controller = editorFor(task: existing);
      controller.title.text = 'Renomeada';

      expect(controller.buildTask()!.id, 'abc');
      controller.dispose();
    });

    test('esvaziar a nota apaga a descrição', () {
      final controller = editorFor(task: existing);
      controller.notes.text = '';

      expect(controller.buildTask()!.description, isNull);
      controller.dispose();
    });
  });

  group('data e hora', () {
    test('marcar hora sem data assume hoje', () {
      final controller = editorFor();
      controller.setDueTime(const TimeOfDay(hour: 8, minute: 0));

      expect(
        controller.draft.value.dueDate,
        DateUtils.dateOnly(DateTime.now()),
      );
      controller.dispose();
    });

    test('limpar a data leva a hora junto', () {
      final controller = editorFor();
      controller.setDueDate(DateTime(2026, 5, 17));
      controller.setDueTime(const TimeOfDay(hour: 8, minute: 0));

      controller.clearDueDate();

      expect(controller.draft.value.dueDate, isNull);
      expect(controller.draft.value.dueTime, isNull);
      controller.dispose();
    });

    test('limpar a hora preserva a data', () {
      final controller = editorFor();
      controller.setDueDate(DateTime(2026, 5, 17));
      controller.setDueTime(const TimeOfDay(hour: 8, minute: 0));

      controller.clearDueTime();

      expect(controller.draft.value.dueDate, DateTime(2026, 5, 17));
      expect(controller.draft.value.dueTime, isNull);
      controller.dispose();
    });
  });

  group('lembrete', () {
    test('só liga quando o sistema autoriza', () async {
      final controller = editorFor(permissionGranted: true);

      expect(await controller.enableReminder(), isTrue);
      expect(controller.draft.value.hasReminder, isTrue);
      // Precisa de um vencimento para ter quando disparar.
      expect(controller.draft.value.dueDate, isNotNull);

      controller.dispose();
    });

    test('permissão negada deixa o lembrete desligado', () async {
      final controller = editorFor(permissionGranted: false);

      expect(await controller.enableReminder(), isFalse);
      expect(controller.draft.value.hasReminder, isFalse);

      controller.dispose();
    });

    test('limpar a data desliga o lembrete', () async {
      final controller = editorFor();
      await controller.enableReminder();

      controller.clearDueDate();

      expect(controller.draft.value.hasReminder, isFalse);
      controller.dispose();
    });
  });

  group('local', () {
    test('texto em branco vira nulo', () {
      final controller = editorFor();
      controller.setLocation('   ');

      expect(controller.draft.value.location, isNull);
      controller.dispose();
    });
  });
}
