import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'passwords.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_passwords(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        password TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<int> savePassword(String title, String password) async {
    final db = await database;
    return await db.insert(
      'saved_passwords',
      {
        'title': title,
        'password': password,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getSavedPasswords() async {
    final db = await database;
    return await db.query('saved_passwords', orderBy: 'created_at DESC');
  }

  Future<int> deletePassword(int id) async {
    final db = await database;
    return await db.delete(
      'saved_passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
