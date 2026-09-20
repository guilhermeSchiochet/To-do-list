import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Níveis de urgência de uma tarefa, em ordem crescente.
/// A task's urgency levels, in ascending order.
enum TaskPriority { low, medium, high }

extension TaskPriorityExtension on TaskPriority {
  /// Rótulo exibido no seletor de prioridade.
  String get label => switch (this) {
        TaskPriority.low => strings.priorityLow,
        TaskPriority.medium => strings.priorityMedium,
        TaskPriority.high => strings.priorityHigh,
      };

  /// Cor do ponto indicador ao lado da tarefa.
  Color get color => switch (this) {
        TaskPriority.low => AppPalette.indigo,
        TaskPriority.medium => AppPalette.yellow,
        TaskPriority.high => AppPalette.red,
      };
}
