import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// O botão redondo de nova tarefa, com o brilho azul do mockup.
/// The round new-task button, with the blue glow from the mockup.
///
/// Compartilhado pela barra inferior e pela barra lateral.
class NewTaskButton extends StatefulWidget {
  final double size;
  final VoidCallback onPressed;

  const NewTaskButton({super.key, this.size = 56, required this.onPressed});

  @override
  State<NewTaskButton> createState() => _NewTaskButtonState();
}

class _NewTaskButtonState extends State<NewTaskButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: strings.newTaskTitle,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          setState(() => _isPressed = false);
          HapticFeedback.mediumImpact();
          widget.onPressed();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _isPressed ? 0.92 : 1,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: AppPalette.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primary.withValues(alpha: 0.4),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: widget.size * 0.54,
            ),
          ),
        ),
      ),
    );
  }
}
