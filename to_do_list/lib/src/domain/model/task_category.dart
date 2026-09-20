import 'package:flutter/material.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// As listas em que uma tarefa pode ser organizada.
/// The lists a task can be organized into.
///
/// Fonte única de verdade: rótulo, ícone e cor de cada categoria vivem aqui,
/// e não espalhados pelas telas.
enum TaskCategory {
  work(Color(0xFFFFC300), Icons.work_rounded),
  personal(Color(0xFF5E5CE6), Icons.person_rounded),
  shopping(Color(0xFF34C759), Icons.shopping_cart_rounded),
  health(Color(0xFFFF2D92), Icons.favorite_rounded),
  travel(Color(0xFF32ADE6), Icons.flight_rounded);

  /// Cor do marcador circular da categoria.
  final Color color;

  /// Ícone exibido dentro do marcador.
  final IconData icon;

  const TaskCategory(this.color, this.icon);

  /// Nome traduzido para exibição.
  String get label => switch (this) {
        TaskCategory.work => strings.categoryWork,
        TaskCategory.personal => strings.categoryPersonal,
        TaskCategory.shopping => strings.categoryShopping,
        TaskCategory.health => strings.categoryHealth,
        TaskCategory.travel => strings.categoryTravel,
      };

  /// Converte o valor persistido no banco de volta para o enum.
  /// Aceita o nome do enum e também os rótulos em inglês gravados pelas
  /// versões anteriores do app.
  static TaskCategory fromStorage(String? value) {
    if (value == null) return TaskCategory.personal;
    final normalized = value.toLowerCase();
    return TaskCategory.values.firstWhere(
      (category) => category.name == normalized,
      orElse: () => TaskCategory.personal,
    );
  }
}
