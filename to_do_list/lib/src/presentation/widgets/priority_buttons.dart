import 'package:flutter/material.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

class PriorityButtons extends StatelessWidget {
  final void Function(TaskPriority priority)? selectedPriority;

  PriorityButtons({super.key, this.selectedPriority});

  final priority = ValueNotifier<TaskPriority>(TaskPriority.medium);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildTitle(),
          const SizedBox(height: 15),

          ValueListenableBuilder(
            valueListenable: priority,
            builder: (_, selected, __) {
              return Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      alignment: selected.alignment,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: FractionallySizedBox(
                          widthFactor: 1 / TaskPriority.values.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: TaskPriority.values.map((value) {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              priority.value = value;
                              selectedPriority?.call(value);
                            },
                            child: _segment(value, selected == value),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Priority',
      style: TextStyle(
        color: Color.fromRGBO(142, 142, 147, 1),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }


  Widget _segment(TaskPriority p, bool selected) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      style: TextStyle(
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        color: selected ? Colors.black : Colors.grey[600],
      ),
      child: Center(
        child: Text(p.toShortString()),
      ),
    );
  }
}
