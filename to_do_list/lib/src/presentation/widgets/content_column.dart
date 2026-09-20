import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/layout/app_layout.dart';

/// Centraliza o conteúdo e limita a largura dele.
/// Centers the content and caps its width.
///
/// Numa janela larga, uma lista esticada de ponta a ponta deixa o título da
/// tarefa num canto e o ponto de prioridade no outro. Em telas estreitas o
/// teto nunca é alcançado e o widget não muda nada.
class ContentColumn extends StatelessWidget {
  final Widget child;

  const ContentColumn({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: child,
      ),
    );
  }
}
