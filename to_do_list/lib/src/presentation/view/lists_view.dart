import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/lists_controller.dart';
import 'package:to_do_list/src/presentation/view/filtered_tasks_view.dart';
import 'package:to_do_list/src/presentation/widgets/grouped_section.dart';
import 'package:to_do_list/src/presentation/widgets/large_title_header.dart';
import 'package:to_do_list/src/presentation/widgets/my_button_bar.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';
import 'package:to_do_list/src/utils/extensions/task_list_extension.dart';

/// Visão geral das listas: os atalhos inteligentes no topo e as categorias
/// do usuário abaixo.
/// Overview of the lists: the smart shortcuts on top and the user's
/// categories below.
class ListsView extends StatefulWidget {
  final List<TaskModel> tasks;
  final TaskActions actions;

  const ListsView({super.key, required this.tasks, required this.actions});

  @override
  State<ListsView> createState() => _ListsViewState();
}

class _ListsViewState extends State<ListsView> {
  final ListsController _controller = ListsController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openList(String title, List<TaskModel> tasks) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FilteredTasksView(
          title: title,
          tasks: tasks,
          actions: widget.actions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ListsState>(
      valueListenable: _controller.state,
      builder: (context, state, _) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header(state)),
          _smartListGrid(),
          SliverToBoxAdapter(child: _myListsTitle()),
          _categoryCard(state),
          const SliverToBoxAdapter(
            child: SizedBox(height: MyBottomBar.contentInset),
          ),
        ],
      ),
    );
  }

  Widget _header(ListsState state) {
    return LargeTitleHeader(
      title: strings.listsTitle,
      actions: [
        TextButton(
          onPressed: _controller.toggleEditing,
          child: Text(
            state.isEditing ? strings.listsDone : strings.listsEdit,
            style: TextStyle(
              color: AppPalette.primary,
              fontSize: 17,
              fontWeight:
                  state.isEditing ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _smartListGrid() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      sliver: SliverGrid(
        // Altura fixa em vez de proporção: com proporção, uma coluna larga
        // esticava o cartão para 300px e o conteúdo ficava boiando.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 104,
        ),
        delegate: SliverChildListDelegate([
          for (final (index, list) in _controller.smartLists(widget.tasks).indexed)
            _SmartListCard(
              list: list,
              onTap: () => _openList(list.title, list.tasks),
            )
                .animate()
                .fadeIn(duration: 350.ms, delay: (index * 70).ms)
                .slideY(
                  begin: 0.12,
                  end: 0,
                  duration: 350.ms,
                  delay: (index * 70).ms,
                  curve: Curves.easeOutQuad,
                ),
        ]),
      ),
    );
  }

  Widget _myListsTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 10),
      child: Text(
        strings.listsMyLists,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.4,
          color: context.colors.label,
        ),
      ),
    );
  }

  Widget _categoryCard(ListsState state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: GroupedSection(
          children: [
            for (final category in _controller.visibleCategories())
              _CategoryRow(
                category: category,
                count: widget.tasks.inCategory(category).length,
                isEditing: state.isEditing,
                isHidden: state.hidden.contains(category),
                onToggleHidden: () => _controller.toggleHidden(category),
                onTap: () => _openList(
                  category.label,
                  widget.tasks.inCategory(category),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Cartão de atalho, com o ícone à esquerda e a contagem à direita.
class _SmartListCard extends StatelessWidget {
  final SmartList list;
  final VoidCallback onTap;

  const _SmartListCard({required this.list, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoryBadge(icon: list.icon, color: list.color),
                  const Spacer(),
                  Text(
                    '${list.tasks.length}',
                    style: TextStyle(
                      fontSize: 26,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: colors.label,
                    ),
                  ),
                ],
              ),
              Text(
                list.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Linha de uma categoria do usuário.
class _CategoryRow extends StatelessWidget {
  final TaskCategory category;
  final int count;
  final bool isEditing;
  final bool isHidden;
  final VoidCallback onToggleHidden;
  final VoidCallback onTap;

  const _CategoryRow({
    required this.category,
    required this.count,
    required this.isEditing,
    required this.isHidden,
    required this.onToggleHidden,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Em edição o toque liga e desliga a lista em vez de abri-la.
        onTap: isEditing ? onToggleHidden : onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isEditing && isHidden ? 0.4 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (isEditing) ...[
                  Icon(
                    isHidden
                        ? Icons.remove_circle_outline_rounded
                        : Icons.check_circle_rounded,
                    size: 22,
                    color: isHidden ? colors.secondaryLabel : AppPalette.green,
                  ),
                  const SizedBox(width: 12),
                ],
                _CategoryBadge(icon: category.icon, color: category.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: colors.label,
                    ),
                  ),
                ),
                if (!isEditing) GroupedDisclosure('$count'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// O círculo colorido que identifica uma lista.
class _CategoryBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _CategoryBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}
