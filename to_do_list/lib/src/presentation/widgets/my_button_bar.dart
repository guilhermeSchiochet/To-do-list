import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';

class MyBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onTap;

  const MyBottomBar({super.key, this.onTap, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _animatedIconButton(LucideIcons.home, 0, context),
          _animatedIconButton(LucideIcons.calendar, 1, context),
          _animatedIconButton(LucideIcons.listTodo, 3, context),
          _animatedIconButton(LucideIcons.user, 4, context),
        ],
      ),
    );
  }

  Widget _animatedIconButton(IconData icon, int index, BuildContext context) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTap?.call(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          icon,
          size: isSelected ? 30 : 26,
          key: ValueKey<bool>(isSelected),
          color: isSelected ? AppTheme.primaryColor : Colors.grey,
        )
      ),
    );
  }
}