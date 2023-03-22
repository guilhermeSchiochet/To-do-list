import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/data/providers/database_provider.dart';

class TaskProvider {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Future<int> addTask(TaskModel task) async {
    final db = await _databaseProvider.database;

    return await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await _databaseProvider.database;

    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await _databaseProvider.database;

    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await _databaseProvider.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
