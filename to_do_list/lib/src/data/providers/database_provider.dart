// ignore_for_file: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Abre e migra o banco SQLite, em instância única para todo o app.
/// Opens and migrates the SQLite database, as a single instance app-wide.
class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  /// Versão atual do esquema. Incremente ao alterar [_createDb] e adicione
  /// o passo correspondente em [_upgradeDb].
  static const int _schemaVersion = 3;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'to_do_list.db'),
      version: _schemaVersion,
      onCreate: (db, version) => _createDb(db),
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        priority INTEGER NOT NULL DEFAULT 1,
        dueDate TEXT,
        dueTimeMinutes INTEGER,
        category TEXT NOT NULL DEFAULT 'personal',
        isFlagged INTEGER NOT NULL DEFAULT 0,
        hasReminder INTEGER NOT NULL DEFAULT 0,
        location TEXT
      )
    ''');
  }

  /// Migra o esquema preservando as tarefas já salvas.
  /// Migrates the schema while preserving the tasks already saved.
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    // v1 não tinha as colunas de categoria e sinalização, e não há dados
    // relevantes a preservar dessa versão.
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS tasks');
      await _createDb(db);
      return;
    }

    if (oldVersion < 3) {
      await db.execute('ALTER TABLE tasks ADD COLUMN dueTimeMinutes INTEGER');
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN hasReminder INTEGER NOT NULL DEFAULT 0",
      );
      await db.execute('ALTER TABLE tasks ADD COLUMN location TEXT');
      // A categoria passou de rótulo ("Personal") para o nome do enum.
      await db.execute('UPDATE tasks SET category = LOWER(category)');
    }
  }
}
