import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';

/// Seletor segmentado no estilo iOS, com o indicador deslizando entre as
/// opções.
/// An iOS-style segmented control, with the thumb sliding between options.
class SegmentedControl<T> extends StatelessWidget {
  /// Opções na ordem em que aparecem, cada uma com seu rótulo.
  final Map<T, String> segments;

  final T value;

  final ValueChanged<T> onChanged;

  /// Divide a largura disponível igualmente entre as opções, como no
  /// seletor Month/Week. Sem isso cada opção se ajusta ao próprio texto.
  final bool expand;

  const SegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keys = segments.keys.toList();

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.fill,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final key in keys)
            _segment(
              colors: colors,
              label: segments[key]!,
              isSelected: key == value,
              onTap: () {
                if (key == value) return;
                HapticFeedback.selectionClick();
                onChanged(key);
              },
            ),
        ],
      ),
    );
  }

  Widget _segment({
    required AppColors colors,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final segment = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 30,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.selectedFill : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 220),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colors.label : colors.secondaryLabel,
          ),
          child: Text(label),
        ),
      ),
    );

    return expand ? Expanded(child: segment) : segment;
  }
}
