import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/src/data/services/notification_service.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Os campos do formulário que não são texto livre.
/// The form fields that are not free text.
///
/// Ficam juntos num só valor para a tela reconstruir com um único
/// `ValueListenableBuilder`, em vez de um `setState` por campo.
@immutable
class TaskDraft {
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final bool isFlagged;
  final bool hasReminder;
  final String? location;

  const TaskDraft({
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    this.dueDate,
    this.dueTime,
    this.isFlagged = false,
    this.hasReminder = false,
    this.location,
  });

  TaskDraft copyWith({
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    bool? isFlagged,
    bool? hasReminder,
    String? location,
    bool clearDueDate = false,
    bool clearDueTime = false,
    bool clearLocation = false,
  }) {
    return TaskDraft(
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      dueTime: (clearDueTime || clearDueDate) ? null : dueTime ?? this.dueTime,
      isFlagged: isFlagged ?? this.isFlagged,
      hasReminder: hasReminder ?? this.hasReminder,
      location: clearLocation ? null : location ?? this.location,
    );
  }
}

/// Estado e regras do formulário de tarefa.
/// State and rules of the task form.
///
/// Não conhece widgets: a tela abre os seletores e entrega o resultado aqui.
class TaskEditorController {
  /// Tarefa em edição. Nulo quando é uma tarefa nova.
  final TaskModel? task;

  final NotificationService _notifications;

  TaskEditorController({
    this.task,
    DateTime? initialDate,
    NotificationService? notificationService,
  }) : _notifications = notificationService ?? NotificationService.instance {
    title = TextEditingController(text: task?.title ?? '')
      ..addListener(_onTitleChanged);
    notes = TextEditingController(text: task?.description ?? '');

    _draft = ValueNotifier<TaskDraft>(
      TaskDraft(
        priority: task?.priority ?? TaskPriority.medium,
        category: task?.category ?? TaskCategory.personal,
        dueDate: task?.dueDate ?? initialDate,
        dueTime: task?.dueTime,
        isFlagged: task?.isFlagged ?? false,
        hasReminder: task?.hasReminder ?? false,
        location: task?.location,
      ),
    );

    _canSave = ValueNotifier<bool>(title.text.trim().isNotEmpty);
  }

  late final TextEditingController title;
  late final TextEditingController notes;
  late final ValueNotifier<TaskDraft> _draft;
  late final ValueNotifier<bool> _canSave;

  final FocusNode titleFocus = FocusNode();

  ValueListenable<TaskDraft> get draft => _draft;

  /// Se já dá para salvar, ou seja, se o título não está vazio.
  ValueListenable<bool> get canSave => _canSave;

  bool get isEditing => task != null;

  /// Se o teclado deve abrir sozinho: só ao criar, não ao editar.
  bool get autofocusTitle => !isEditing;

  /// Se vale oferecer o lembrete nesta plataforma.
  bool get supportsReminders => _notifications.isSupported;

  // --- Rótulos exibidos -----------------------------------------------

  String? get dueDateLabel {
    final date = _draft.value.dueDate;
    return date == null ? null : DateFormat.yMMMd().format(date);
  }

  String? dueTimeLabel(BuildContext context) =>
      _draft.value.dueTime?.format(context);

  // --- Alterações no rascunho ------------------------------------------

  void setPriority(TaskPriority priority) =>
      _draft.value = _draft.value.copyWith(priority: priority);

  void setCategory(TaskCategory category) =>
      _draft.value = _draft.value.copyWith(category: category);

  void setDueDate(DateTime date) =>
      _draft.value = _draft.value.copyWith(dueDate: date);

  /// Limpar a data leva junto a hora e o lembrete, que dependem dela.
  void clearDueDate() => _draft.value = _draft.value.copyWith(
        clearDueDate: true,
        hasReminder: false,
      );

  /// Marcar uma hora sem ter data assume hoje: hora solta não tem quando
  /// acontecer.
  void setDueTime(TimeOfDay time) => _draft.value = _draft.value.copyWith(
        dueTime: time,
        dueDate: _draft.value.dueDate ?? DateUtils.dateOnly(DateTime.now()),
      );

  void clearDueTime() => _draft.value = _draft.value.copyWith(clearDueTime: true);

  void setFlagged(bool value) =>
      _draft.value = _draft.value.copyWith(isFlagged: value);

  void setLocation(String? value) {
    final trimmed = value?.trim();
    _draft.value = _draft.value.copyWith(
      location: trimmed,
      clearLocation: trimmed == null || trimmed.isEmpty,
    );
  }

  /// Liga o lembrete, mas só depois de o sistema conceder a permissão.
  /// Devolve se conseguiu.
  Future<bool> enableReminder() async {
    if (!supportsReminders) return false;

    final granted =
        _notifications.hasPermission || await _notifications.requestPermission();
    if (!granted) return false;

    _draft.value = _draft.value.copyWith(
      hasReminder: true,
      // Sem vencimento não há quando notificar.
      dueDate: _draft.value.dueDate ?? DateUtils.dateOnly(DateTime.now()),
    );
    return true;
  }

  void disableReminder() =>
      _draft.value = _draft.value.copyWith(hasReminder: false);

  // --- Resultado --------------------------------------------------------

  /// Monta a tarefa a partir do formulário, ou devolve nulo se ainda não
  /// dá para salvar.
  TaskModel? buildTask() {
    final trimmedTitle = title.text.trim();
    if (trimmedTitle.isEmpty) return null;

    final trimmedNotes = notes.text.trim();
    final current = _draft.value;
    final base = task ??
        TaskModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: trimmedTitle,
        );

    return base.copyWith(
      title: trimmedTitle,
      description: trimmedNotes.isEmpty ? null : trimmedNotes,
      clearDescription: trimmedNotes.isEmpty,
      priority: current.priority,
      category: current.category,
      dueDate: current.dueDate,
      clearDueDate: current.dueDate == null,
      dueTime: current.dueTime,
      clearDueTime: current.dueTime == null,
      isFlagged: current.isFlagged,
      hasReminder: current.hasReminder,
      location: current.location,
      clearLocation: current.location == null,
    );
  }

  void _onTitleChanged() => _canSave.value = title.text.trim().isNotEmpty;

  void dispose() {
    title.dispose();
    notes.dispose();
    titleFocus.dispose();
    _draft.dispose();
    _canSave.dispose();
  }
}
