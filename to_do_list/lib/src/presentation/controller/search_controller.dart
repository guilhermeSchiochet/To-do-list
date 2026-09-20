import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

/// O que a tela de busca deve desenhar agora.
/// What the search screen should draw right now.
enum SearchStatus {
  /// Nada digitado ainda.
  idle,

  /// Há um termo, mas nenhuma tarefa casa com ele.
  empty,

  /// Há resultados.
  results,
}

/// Estado da busca: o termo e o que ele produziu.
/// Search state: the term and what it produced.
class TaskSearchController {
  /// Nome com prefixo porque o Material já exporta um `SearchController`.
  TaskSearchController();

  final TextEditingController field = TextEditingController();
  final ValueNotifier<String> _query = ValueNotifier<String>('');

  /// Termo já sem espaços nas pontas.
  ValueListenable<String> get query => _query;

  void onQueryChanged(String value) => _query.value = value.trim();

  void clear() {
    field.clear();
    _query.value = '';
  }

  /// Tarefas que casam com o termo atual.
  List<TaskModel> results(List<TaskModel> tasks) => tasks.matching(_query.value);

  SearchStatus statusFor(List<TaskModel> results) {
    if (_query.value.isEmpty) return SearchStatus.idle;
    return results.isEmpty ? SearchStatus.empty : SearchStatus.results;
  }

  void dispose() {
    field.dispose();
    _query.dispose();
  }
}
