// ignore_for_file: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// DatabaseProvider class to manage database operations
// Classe DatabaseProvider para gerenciar operações do banco de dados
class DatabaseProvider {
  // Singleton instance of the DatabaseProvider
  // Instância singleton do DatabaseProvider
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  // Factory constructor to return the singleton instance
  // Construtor factory para retornar a instância singleton
  factory DatabaseProvider() {
    return _instance;
  }

  // Private constructor for singleton pattern
  // Construtor privado para o padrão singleton
  DatabaseProvider._internal();

  // Nullable database object
  // Objeto de banco de dados nulo
  Database? _database;

  // Getter for the database object, initializes if not yet created
  // Getter para o objeto do banco de dados, inicializa se ainda não foi criado
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initializes the database
  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'to_do_list.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            isCompleted INTEGER,
            priority INTEGER
          )
        ''');
      },
      version: 1,
    );
  }
}
