import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mood.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mood_tracker_final.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE moods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        mood_level INTEGER NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        image_path TEXT
      )
    ''');
  }

  Future<int> insertMood(Mood mood) async {
    final db = await instance.database;
    return await db.insert('moods', mood.toMap());
  }

  Future<List<Mood>> getAllMoods() async {
    final db = await instance.database;
    final result = await db.query('moods', orderBy: 'date DESC');
    return result.map((json) => Mood.fromMap(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getMoodStats() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT mood, COUNT(*) as total 
      FROM moods 
      GROUP BY mood 
      ORDER BY total DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getMoodStatsByDate(
      String dateQuery) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT mood, COUNT(*) as total 
      FROM moods 
      WHERE date LIKE '$dateQuery%' 
      GROUP BY mood
      ORDER BY total DESC
    ''');
  }

  Future<int> deleteMood(int id) async {
    final db = await instance.database;
    return await db.delete(
      'moods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
