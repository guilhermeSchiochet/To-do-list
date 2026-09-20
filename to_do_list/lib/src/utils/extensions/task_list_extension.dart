import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Os recortes de tarefas que as telas pedem, definidos uma vez só.
/// The task subsets the screens ask for, defined in a single place.
///
/// Antes cada tela repetia o próprio `where`, e "o que conta como hoje"
/// tinha uma resposta diferente em cada arquivo.
extension TaskListExtension on Iterable<TaskModel> {
  /// Tarefas ainda em aberto.
  List<TaskModel> get pending =>
      where((task) => !task.isCompleted).toList();

  /// Tarefas já concluídas.
  List<TaskModel> get completed =>
      where((task) => task.isCompleted).toList();

  /// Tarefas marcadas com a bandeira.
  List<TaskModel> get flagged => where((task) => task.isFlagged).toList();

  /// Tarefas com data marcada.
  List<TaskModel> get scheduled =>
      where((task) => task.dueDate != null).toList();

  /// O que a tela Today mostra: tudo que não está agendado para outro dia,
  /// ou seja, vence hoje, está atrasado ou nem tem data.
  ///
  /// Tarefas sem data ficam aqui de propósito: em nenhuma outra tela elas
  /// apareceriam sozinhas, e some-las seria perdê-las de vista.
  List<TaskModel> get forToday {
    final today = DateUtils.dateOnly(DateTime.now());

    return where((task) {
      final due = task.dueDate;
      return due == null || !due.isAfter(today);
    }).toList();
  }

  /// Tarefas que vencem no dia informado.
  List<TaskModel> on(DateTime date) =>
      where((task) => DateUtils.isSameDay(task.dueDate, date)).toList();

  /// Tarefas de uma lista.
  List<TaskModel> inCategory(TaskCategory category) =>
      where((task) => task.category == category).toList();

  /// Tarefas cujo texto casa com o termo, sem diferenciar maiúsculas.
  /// Procura no título, na nota, no nome da lista e no local.
  List<TaskModel> matching(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const [];

    return where((task) {
      final haystack = [
        task.title,
        task.description ?? '',
        task.category.label,
        task.location ?? '',
      ].join(' ').toLowerCase();

      return haystack.contains(needle);
    }).toList();
  }
}
