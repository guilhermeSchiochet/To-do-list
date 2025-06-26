import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onTap;

  const MyBottomBar({super.key, this.onTap, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconButton(LucideIcons.home, 0),
          _iconButton(LucideIcons.calendar, 1),
          _centerButton(context),
          _iconButton(LucideIcons.listTodo, 3),
          _iconButton(LucideIcons.user, 4),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index ? Colors.blue : Colors.grey,
      ),
      onPressed: () => onTap?.call(index),
    );
  }

  Widget _centerButton(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () => onTap?.call(2),
      ),
    );
  }
}