import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/domain/model/task_model.dart';
import 'package:to_do_list/data/providers/database_provider.dart';

// TaskProvider class to manage Task-related database operations
// Classe TaskProvider para gerenciar operações do banco de dados relacionadas às tarefas
class TaskProvider {
  // Instance of the DatabaseProvider
  // Instância do DatabaseProvider
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  // Add a new task to the database
  // Adicionar uma nova tarefa ao banco de dados
  Future<int> addTask(TaskModel task) async {
    final db = await _databaseProvider.database;

    return await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all tasks from the database
  // Obter todas as tarefas do banco de dados
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _databaseProvider.database;

    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // Update an existing task in the database
  // Atualizar uma tarefa existente no banco de dados
  Future<int> updateTask(TaskModel task) async {
    final db = await _databaseProvider.database;

    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task from the database using its ID
  // Excluir uma tarefa do banco de dados usando seu ID
  Future<int> deleteTask(String id) async {
    final db = await _databaseProvider.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
