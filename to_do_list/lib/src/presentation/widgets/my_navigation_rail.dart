import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:to_do_list/src/config/layout/app_layout.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/presentation/controller/home_screen_controller.dart';
import 'package:to_do_list/src/presentation/widgets/new_task_button.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Barra de navegação vertical, usada no lugar da inferior quando a janela
/// é larga.
/// Vertical navigation bar, used instead of the bottom one on wide windows.
///
/// Recebe o mesmo par [HomeTab] + callback da barra inferior, então a tela
/// principal só escolhe entre as duas.
class MyNavigationRail extends StatelessWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTap;

  const MyNavigationRail({
    super.key,
    required this.selectedTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: AppLayout.railWidth,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.separator, width: 0.5)),
      ),
      child: Column(
        children: [
          // A ação principal fica no topo, onde o desktop costuma colocá-la.
          const SizedBox(height: 20),
          NewTaskButton(size: 48, onPressed: () => onTap(HomeTab.newTask)),
          const SizedBox(height: 28),
          _RailItem(
            icon: LucideIcons.listTodo,
            label: strings.navToday,
            isSelected: selectedTab == HomeTab.today,
            onTap: () => onTap(HomeTab.today),
          ),
          _RailItem(
            icon: LucideIcons.calendar,
            label: strings.navCalendar,
            isSelected: selectedTab == HomeTab.calendar,
            onTap: () => onTap(HomeTab.calendar),
          ),
          _RailItem(
            icon: LucideIcons.layoutGrid,
            label: strings.navLists,
            isSelected: selectedTab == HomeTab.lists,
            onTap: () => onTap(HomeTab.lists),
          ),
          const Spacer(),
          _RailItem(
            icon: LucideIcons.settings,
            label: strings.navSettings,
            isSelected: selectedTab == HomeTab.settings,
            onTap: () => onTap(HomeTab.settings),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Um destino do rail: ícone sobre o rótulo, com uma pílula atrás quando
/// está ativo.
class _RailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isSelected ? AppPalette.primary : colors.secondaryLabel;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (!isSelected) HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        // O mouse pede um retorno que o toque não pede.
        hoverColor: colors.fill,
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 56,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppPalette.primary.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 21, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
