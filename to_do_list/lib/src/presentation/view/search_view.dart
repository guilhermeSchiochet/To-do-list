import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/search_controller.dart';
import 'package:to_do_list/src/presentation/widgets/content_column.dart';
import 'package:to_do_list/src/presentation/widgets/empty_state.dart';
import 'package:to_do_list/src/presentation/widgets/screen_app_bar.dart';
import 'package:to_do_list/src/presentation/widgets/task_list.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Busca por título, nota, lista ou local.
/// Search by title, notes, list or location.
class SearchView extends StatefulWidget {
  final List<TaskModel> tasks;
  final TaskActions actions;

  const SearchView({super.key, required this.tasks, required this.actions});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TaskSearchController _controller = TaskSearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: strings.searchTitle),
      body: SafeArea(
        child: ValueListenableBuilder<String>(
          valueListenable: _controller.query,
          builder: (context, query, _) {
            final results = _controller.results(widget.tasks);

            return ContentColumn(
              child: Column(
                children: [
                  _searchField(query),
                  Expanded(
                    child: switch (_controller.statusFor(results)) {
                      SearchStatus.idle => EmptyState(
                          icon: Icons.search_rounded,
                          title: strings.searchEmptyTitle,
                          subtitle: strings.searchEmptySubtitle,
                        ),
                      SearchStatus.empty => EmptyState(
                          icon: Icons.sentiment_dissatisfied_rounded,
                          title: strings.searchNoResults(query),
                          subtitle: strings.searchEmptySubtitle,
                        ),
                      SearchStatus.results => TaskList(
                          tasks: results,
                          actions: widget.actions,
                          bottomPadding: 24,
                        ),
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _searchField(String query) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: TextField(
        controller: _controller.field,
        autofocus: true,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 17, color: colors.label),
        onChanged: _controller.onQueryChanged,
        decoration: InputDecoration(
          hintText: strings.searchHint,
          hintStyle: TextStyle(color: colors.secondaryLabel),
          filled: true,
          fillColor: colors.fill,
          prefixIcon: Icon(Icons.search_rounded, color: colors.secondaryLabel),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  onPressed: _controller.clear,
                  icon: Icon(
                    Icons.cancel_rounded,
                    size: 18,
                    color: colors.secondaryLabel,
                  ),
                ),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
