import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL
    )
    ''');
  }

  Future<int> insertUser(int userId) async {
    final db = await instance.database;

    // Limpiar usuarios anteriores (solo 1 guardado)
    await db.delete('user');

    return await db.insert('user', {'user_id': userId});
  }

  Future<int?> getUserId() async {
    final db = await instance.database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) {
      return result.first['user_id'] as int;
    }
    return null;
  }

  Future<void> logout() async {
    final db = await instance.database;
    await db.delete('user');
  }
}
