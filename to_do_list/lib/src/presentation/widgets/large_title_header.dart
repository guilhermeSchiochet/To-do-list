import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';

/// Cabeçalho de topo de tela, com o título grande do iOS.
/// Screen header with the large iOS-style title.
class LargeTitleHeader extends StatelessWidget {
  /// Linha pequena em maiúsculas acima do título, como a data em Today.
  final String? eyebrow;

  final String title;

  /// Ações à direita, alinhadas à base do título.
  final List<Widget> actions;

  const LargeTitleHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (eyebrow != null) ...[
                  Text(
                    eyebrow!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: colors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                    color: colors.label,
                  ),
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: actions),
            ),
        ],
      ),
    );
  }
}

/// Botão circular de ícone usado nas ações do cabeçalho.
/// Circular icon button used in the header actions.
class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 26, color: AppPalette.primary),
      splashRadius: 22,
    );
  }
}
