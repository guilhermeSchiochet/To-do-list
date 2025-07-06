import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animations/animations.dart';

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
          _animatedIconButton(LucideIcons.home, 0),
          _animatedIconButton(LucideIcons.calendar, 1),
          _centerButton(context),
          _animatedIconButton(LucideIcons.listTodo, 3),
          _animatedIconButton(LucideIcons.user, 4),
        ],
      ),
    );
  }

  Widget _animatedIconButton(IconData icon, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: FadeScaleTransition(
        animation: AlwaysStoppedAnimation(1.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          padding: EdgeInsets.all(isSelected ? 16 : 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: isSelected ? 28 : 24,
          ),
        ),
      ),
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
