import 'package:intl/intl.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

/// Os dados que a tela Today exibe, derivados da lista de tarefas.
/// The data the Today screen shows, derived from the task list.
class TodayController {
  const TodayController();

  /// Tarefas que a tela mostra.
  List<TaskModel> visibleTasks(List<TaskModel> tasks) => tasks.forToday;

  /// Quantas dessas já foram concluídas.
  int completedCount(List<TaskModel> visibleTasks) =>
      visibleTasks.completed.length;

  /// A data em maiúsculas exibida acima do título.
  String headerDate([DateTime? now]) =>
      DateFormat('EEEE, MMM d').format(now ?? DateTime.now()).toUpperCase();
}
