import 'package:flutter/material.dart';
import 'package:to_do_list/src/domain/useCases/add_use_case.dart';
import 'package:to_do_list/src/domain/useCases/delete_use_case.dart';
import 'package:to_do_list/src/domain/useCases/update_use_case.dart';
import 'package:to_do_list/src/presentation/screens/calendar_screen.dart';
import 'package:to_do_list/src/presentation/screens/home_screen.view.dart';
import 'package:to_do_list/src/presentation/widgets/my_button_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  const MainNavigationScreen({
    super.key,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {

  final ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final PageController controller = PageController();

  late final List<Widget> pages = [
    HomeScreenView(
      addTaskUseCase: widget.addTaskUseCase,
      deleteTaskUseCase: widget.deleteTaskUseCase,
      updateTaskUseCase: widget.updateTaskUseCase,
    ),
    const CalendarScreen(),
    const Placeholder(),
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) => selectedIndex.value = index,
        children: pages,
      ),

      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (_, index, __) {
          return MyBottomBar(
            selectedIndex: index,
            onTap: (i) {
              selectedIndex.value = i;
              controller.animateToPage(
                i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          );
        },
      ),
    );
  }
}