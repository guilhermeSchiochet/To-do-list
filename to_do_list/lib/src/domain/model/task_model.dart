import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Uma tarefa. Imutável: toda alteração passa por [copyWith].
/// A task. Immutable: every change goes through [copyWith].
@immutable
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final TaskPriority priority;

  /// Dia de vencimento, sempre normalizado para meia-noite.
  /// A hora, quando existe, fica em [dueTime].
  final DateTime? dueDate;

  /// Hora de vencimento. Só faz sentido quando [dueDate] está preenchido.
  final TimeOfDay? dueTime;

  final TaskCategory category;
  final bool isFlagged;

  /// Se o usuário pediu uma notificação para esta tarefa.
  final bool hasReminder;

  final String? location;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    DateTime? dueDate,
    this.dueTime,
    this.category = TaskCategory.personal,
    this.isFlagged = false,
    this.hasReminder = false,
    this.location,
  }) : dueDate = dueDate == null ? null : DateUtils.dateOnly(dueDate);

  /// Data e hora completas do vencimento, para agendar lembretes e ordenar.
  /// Sem [dueDate] não há vencimento; sem [dueTime] assume o início do dia.
  DateTime? get dueAt {
    if (dueDate == null) return null;
    return DateTime(
      dueDate!.year,
      dueDate!.month,
      dueDate!.day,
      dueTime?.hour ?? 0,
      dueTime?.minute ?? 0,
    );
  }

  /// Se a tarefa vence hoje.
  bool get isDueToday =>
      dueDate != null && DateUtils.isSameDay(dueDate, DateTime.now());

  /// Se o vencimento já passou e a tarefa continua aberta.
  bool get isOverdue {
    final due = dueAt;
    if (due == null || isCompleted) return false;
    return due.isBefore(DateTime.now()) && !isDueToday;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final minutes = json['dueTimeMinutes'] as int?;

    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] == 1,
      priority: TaskPriority.values[json['priority'] as int? ?? 1],
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'] as String)
          : null,
      dueTime: minutes == null
          ? null
          : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      category: TaskCategory.fromStorage(json['category'] as String?),
      isFlagged: json['isFlagged'] == 1,
      hasReminder: json['hasReminder'] == 1,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority.index,
      'dueDate': dueDate?.toIso8601String(),
      'dueTimeMinutes':
          dueTime == null ? null : dueTime!.hour * 60 + dueTime!.minute,
      'category': category.name,
      'isFlagged': isFlagged ? 1 : 0,
      'hasReminder': hasReminder ? 1 : 0,
      'location': location,
    };
  }

  /// Copia a tarefa alterando apenas os campos informados.
  ///
  /// Campos opcionais precisam de um sinalizador próprio para poderem ser
  /// limpos, já que `null` significa "não alterar".
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TaskCategory? category,
    bool? isFlagged,
    bool? hasReminder,
    String? location,
    bool clearDescription = false,
    bool clearDueDate = false,
    bool clearDueTime = false,
    bool clearLocation = false,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      // Limpar a data também remove a hora: hora sem dia não faz sentido.
      dueTime:
          (clearDueTime || clearDueDate) ? null : dueTime ?? this.dueTime,
      category: category ?? this.category,
      isFlagged: isFlagged ?? this.isFlagged,
      hasReminder: hasReminder ?? this.hasReminder,
      location: clearLocation ? null : location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          other.id == id &&
          other.title == title &&
          other.description == description &&
          other.isCompleted == isCompleted &&
          other.priority == priority &&
          other.dueDate == dueDate &&
          other.dueTime == dueTime &&
          other.category == category &&
          other.isFlagged == isFlagged &&
          other.hasReminder == hasReminder &&
          other.location == location;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        isCompleted,
        priority,
        dueDate,
        dueTime,
        category,
        isFlagged,
        hasReminder,
        location,
      );
}
