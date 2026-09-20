import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/presentation/controller/home_screen_controller.dart';
import 'package:to_do_list/src/presentation/widgets/new_task_button.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Barra de navegação inferior translúcida, com o botão de nova tarefa
/// elevado no centro.
/// Translucent bottom navigation bar, with the new-task button raised in
/// the middle.
class MyBottomBar extends StatelessWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTap;

  const MyBottomBar({
    super.key,
    required this.selectedTab,
    required this.onTap,
  });

  /// Altura da barra, sem contar a área segura do aparelho.
  static const double barHeight = 60;

  /// Diâmetro do botão de nova tarefa.
  static const double _centerButtonSize = 56;

  /// Quanto do botão central fica acima da borda da barra.
  static const double _centerButtonOverlap = 26;

  /// Espaço que uma lista precisa deixar no fim para o último item não
  /// terminar embaixo da barra.
  static const double contentInset = barHeight + _centerButtonOverlap + 24;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: barHeight + bottomInset + _centerButtonOverlap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        // O botão central ultrapassa a barra e não pode ser recortado.
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  height: barHeight + bottomInset,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  decoration: BoxDecoration(
                    color: colors.background.withValues(alpha: 0.78),
                    border: Border(
                      top: BorderSide(color: colors.separator, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      _NavItem(
                        icon: LucideIcons.listTodo,
                        label: strings.navToday,
                        isSelected: selectedTab == HomeTab.today,
                        onTap: () => onTap(HomeTab.today),
                      ),
                      _NavItem(
                        icon: LucideIcons.calendar,
                        label: strings.navCalendar,
                        isSelected: selectedTab == HomeTab.calendar,
                        onTap: () => onTap(HomeTab.calendar),
                      ),
                      // Espaço reservado para o botão central.
                      const Spacer(),
                      _NavItem(
                        icon: LucideIcons.layoutGrid,
                        label: strings.navLists,
                        isSelected: selectedTab == HomeTab.lists,
                        onTap: () => onTap(HomeTab.lists),
                      ),
                      _NavItem(
                        icon: LucideIcons.settings,
                        label: strings.navSettings,
                        isSelected: selectedTab == HomeTab.settings,
                        onTap: () => onTap(HomeTab.settings),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: bottomInset +
                barHeight +
                _centerButtonOverlap -
                _centerButtonSize,
            child: NewTaskButton(
              size: _centerButtonSize,
              onPressed: () => onTap(HomeTab.newTask),
            ),
          ),
        ],
      ),
    );
  }
}

/// Um item de navegação: ícone sobre o rótulo, azul quando ativo.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? AppPalette.primary : context.colors.secondaryLabel;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) HapticFeedback.selectionClick();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.08 : 1,
              child: Icon(icon, size: 23, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
