import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/src/data/providers/database_provider.dart';
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Acesso à tabela `tasks`.
/// Access to the `tasks` table.
class TaskProvider {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  /// Insere a tarefa, substituindo caso o id já exista.
  /// Inserts the task, replacing it when the id already exists.
  Future<void> addTask(TaskModel task) async {
    final db = await _databaseProvider.database;

    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retorna todas as tarefas, pendentes antes das concluídas e as mais
  /// urgentes primeiro dentro de cada grupo.
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _databaseProvider.database;

    final rows = await db.query(
      'tasks',
      orderBy: 'isCompleted ASC, dueDate IS NULL, dueDate ASC, '
          'dueTimeMinutes IS NULL, dueTimeMinutes ASC, priority DESC',
    );

    return rows.map(TaskModel.fromJson).toList();
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await _databaseProvider.database;

    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await _databaseProvider.database;

    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
