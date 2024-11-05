import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/models/todo.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late Database _database;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, description TEXT, dueTime TEXT, status INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<List<Todo>> loadTodos() async {
    final List<Map<String, dynamic>> maps = await _database.query('todos');
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> addTodoToDatabase(Todo todo) async {
    await _database.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // update todo 
  Future<void> updateTodoInDatabase(Todo todo) async {
    await _database.update(
      'todos',
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }
  
  Future<void> deleteTodoFromDatabase(String id) async {
    await _database.delete(
      'todos',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
