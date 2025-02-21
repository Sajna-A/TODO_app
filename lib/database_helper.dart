import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        completed INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');

    return result.map((task) {
      return {
        "id": task["id"] as int,
        "title": task["title"],
        "description": task["description"],
        "completed": task["completed"],
      };
    }).toList();
  }

  Future<int> updateTask(int id, Map<String, dynamic> updatedTask) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      updatedTask,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
