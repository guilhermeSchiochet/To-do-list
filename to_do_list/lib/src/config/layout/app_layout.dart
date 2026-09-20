import 'package:flutter/widgets.dart';

/// O quanto de espaço horizontal a tela tem para trabalhar.
/// How much horizontal room the screen has to work with.
enum LayoutSize {
  /// Celular em pé, ou uma janela estreita no desktop.
  compact,

  /// Tablet, paisagem ou uma janela larga no desktop.
  expanded,
}

/// Medidas de layout que dependem do tamanho da janela.
/// Layout measurements that depend on the window size.
///
/// A decisão é sempre pela largura disponível, nunca pela plataforma: uma
/// janela estreita no Windows merece o mesmo layout de um celular, e assim
/// tablet e paisagem ficam resolvidos junto.
abstract final class AppLayout {
  /// A partir daqui a tela deixa de ser tratada como celular em pé.
  static const double expandedBreakpoint = 720;

  /// Largura máxima de uma coluna de conteúdo.
  ///
  /// Sem esse teto, numa janela de 1400px o título de uma tarefa fica num
  /// canto e o ponto de prioridade no outro.
  static const double maxContentWidth = 640;

  /// Largura da barra lateral de navegação.
  static const double railWidth = 88;
}

/// Atalho para ler o tamanho de layout atual.
/// Shortcut to read the current layout size.
extension AppLayoutX on BuildContext {
  LayoutSize get layout =>
      MediaQuery.sizeOf(this).width >= AppLayout.expandedBreakpoint
          ? LayoutSize.expanded
          : LayoutSize.compact;

  /// Se há espaço para a barra lateral e a coluna centrada.
  bool get isExpandedLayout => layout == LayoutSize.expanded;
}
