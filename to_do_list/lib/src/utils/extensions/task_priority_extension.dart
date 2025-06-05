import 'package:flutter/material.dart';

enum TaskPriority {low, medium, high }

extension TaskPriorityExtension on TaskPriority {

  String toShortString() {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Med';
      case TaskPriority.high:
        return 'High';
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.high:
        return Icons.priority_high;
      case TaskPriority.medium:
        return Icons.indeterminate_check_box_outlined;
      default:
        return Icons.low_priority;
    }
  }
}