import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/domain/model/task_category.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';
import 'package:to_do_list/src/presentation/controller/task_editor_controller.dart';
import 'package:to_do_list/src/presentation/widgets/grouped_section.dart';
import 'package:to_do_list/src/presentation/widgets/segmented_control.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';
import 'package:to_do_list/src/utils/extensions/task_priority_extension.dart';

/// Folha de criação e edição de tarefas.
/// Sheet for creating and editing tasks.
///
/// Abra por [TaskEditorView.show], que devolve a tarefa salva, ou `null` se
/// o usuário cancelar.
class TaskEditorView extends StatefulWidget {
  /// Tarefa sendo editada. Nulo cria uma nova.
  final TaskModel? task;

  /// Data já selecionada ao criar a tarefa, usada pelo calendário.
  final DateTime? initialDate;

  /// Chamado quando o usuário exclui a tarefa em edição.
  final VoidCallback? onDelete;

  const TaskEditorView({
    super.key,
    this.task,
    this.initialDate,
    this.onDelete,
  });

  /// Abre o editor como folha modal.
  static Future<TaskModel?> show(
    BuildContext context, {
    TaskModel? task,
    DateTime? initialDate,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet<TaskModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditorView(
        task: task,
        initialDate: initialDate,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<TaskEditorView> createState() => _TaskEditorViewState();
}

class _TaskEditorViewState extends State<TaskEditorView> {
  late final TaskEditorController _controller = TaskEditorController(
    task: widget.task,
    initialDate: widget.initialDate,
  );

  @override
  void initState() {
    super.initState();

    if (_controller.autofocusTitle) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _controller.titleFocus.requestFocus(),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final task = _controller.buildTask();
    if (task != null) Navigator.of(context).pop(task);
  }

  // --- Seletores: dependem de contexto, então ficam na tela --------------

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _controller.draft.value.dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) _controller.setDueDate(picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _controller.draft.value.dueTime ?? TimeOfDay.now(),
    );

    if (picked != null) _controller.setDueTime(picked);
  }

  Future<void> _pickCategory() async {
    final picked = await showModalBottomSheet<TaskCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _CategoryPicker(selected: _controller.draft.value.category),
    );

    if (picked != null) _controller.setCategory(picked);
  }

  Future<void> _editLocation() async {
    final field =
        TextEditingController(text: _controller.draft.value.location ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.locationDialogTitle),
        content: TextField(
          controller: field,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(color: context.colors.label),
          decoration: InputDecoration(hintText: strings.locationDialogHint),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(field.text),
            child: Text(strings.save),
          ),
        ],
      ),
    );

    field.dispose();
    if (result != null) _controller.setLocation(result);
  }

  Future<void> _toggleReminder(bool enabled) async {
    if (!enabled) {
      _controller.disableReminder();
      return;
    }

    final granted = await _controller.enableReminder();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.reminderPermissionDenied)),
      );
    }
  }

  // --- Composição --------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _header(colors),
          Expanded(
            child: ValueListenableBuilder<TaskDraft>(
              valueListenable: _controller.draft,
              builder: (context, draft, _) => ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 32,
                ),
                children: [
                  _titleAndNotesCard(colors),
                  const SizedBox(height: 22),
                  _detailsSection(colors, draft),
                  const SizedBox(height: 22),
                  _optionsSection(draft),
                  if (_controller.isEditing) ...[
                    const SizedBox(height: 22),
                    _deleteButton(colors),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  strings.cancel,
                  style: const TextStyle(
                    color: AppPalette.primary,
                    fontSize: 17,
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _controller.canSave,
                builder: (context, canSave, _) => TextButton(
                  onPressed: canSave ? _save : null,
                  child: Text(
                    _controller.isEditing ? strings.save : strings.add,
                    style: TextStyle(
                      color:
                          canSave ? AppPalette.primary : colors.secondaryLabel,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              _controller.isEditing
                  ? strings.editTaskTitle
                  : strings.newTaskTitle,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.6,
                color: colors.label,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleAndNotesCard(AppColors colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: colors.surface,
        child: Column(
          children: [
            _field(
              colors: colors,
              controller: _controller.title,
              focusNode: _controller.titleFocus,
              hint: strings.fieldTitleHint,
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              indent: 16,
              color: colors.separator,
            ),
            _field(
              colors: colors,
              controller: _controller.notes,
              hint: strings.fieldNotesHint,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required AppColors colors,
    required TextEditingController controller,
    required String hint,
    FocusNode? focusNode,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 17, color: colors.label),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.secondaryLabel, fontSize: 17),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: InputBorder.none,
      ),
    );
  }

  Widget _detailsSection(AppColors colors, TaskDraft draft) {
    return GroupedSection(
      title: strings.sectionDetails,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.fieldPriority,
                style: TextStyle(fontSize: 17, color: colors.label),
              ),
              const SizedBox(height: 10),
              SegmentedControl<TaskPriority>(
                expand: true,
                value: draft.priority,
                segments: {
                  for (final priority in TaskPriority.values)
                    priority: priority.label,
                },
                onChanged: _controller.setPriority,
              ),
            ],
          ),
        ),
        GroupedRow(
          icon: Icons.calendar_today_rounded,
          iconColor: AppPalette.red,
          title: strings.fieldDueDate,
          onTap: _pickDate,
          trailing: GroupedClearableValue(
            value: _controller.dueDateLabel,
            placeholder: strings.selectDate,
            onClear: _controller.clearDueDate,
          ),
        ),
        GroupedRow(
          icon: Icons.schedule_rounded,
          iconColor: AppPalette.orange,
          title: strings.fieldTime,
          onTap: _pickTime,
          trailing: GroupedClearableValue(
            value: _controller.dueTimeLabel(context),
            placeholder: strings.selectTime,
            onClear: _controller.clearDueTime,
          ),
        ),
        GroupedRow(
          icon: draft.category.icon,
          iconColor: draft.category.color,
          title: strings.fieldList,
          onTap: _pickCategory,
          trailing: GroupedDisclosure(draft.category.label),
        ),
      ],
    );
  }

  Widget _optionsSection(TaskDraft draft) {
    return GroupedSection(
      title: strings.sectionOptions,
      children: [
        GroupedRow(
          icon: Icons.flag_rounded,
          iconColor: AppPalette.orange,
          title: strings.fieldFlag,
          trailing: CupertinoSwitch(
            value: draft.isFlagged,
            activeTrackColor: AppPalette.green,
            onChanged: _controller.setFlagged,
          ),
        ),
        if (_controller.supportsReminders)
          GroupedRow(
            icon: Icons.notifications_rounded,
            iconColor: AppPalette.primary,
            title: strings.fieldRemindMe,
            trailing: CupertinoSwitch(
              value: draft.hasReminder,
              activeTrackColor: AppPalette.green,
              onChanged: _toggleReminder,
            ),
          ),
        GroupedRow(
          icon: Icons.location_on_rounded,
          iconColor: AppPalette.indigo,
          title: strings.fieldLocation,
          onTap: _editLocation,
          trailing: GroupedDisclosure(draft.location ?? strings.none),
        ),
      ],
    );
  }

  Widget _deleteButton(AppColors colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: colors.surface,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            widget.onDelete?.call();
          },
          child: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                strings.delete,
                style: const TextStyle(
                  fontSize: 17,
                  color: AppPalette.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Folha de seleção da lista a que a tarefa pertence.
class _CategoryPicker extends StatelessWidget {
  final TaskCategory selected;

  const _CategoryPicker({required this.selected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GroupedSection(
          title: strings.fieldList.toUpperCase(),
          children: [
            for (final category in TaskCategory.values)
              GroupedRow(
                icon: category.icon,
                iconColor: category.color,
                title: category.label,
                onTap: () => Navigator.of(context).pop(category),
                trailing: category == selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppPalette.primary,
                        size: 22,
                      )
                    : const SizedBox(width: 22),
              ),
          ],
        ),
      ),
    );
  }
}
