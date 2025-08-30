import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'bb_qtmtld_data.sqlite');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS survey_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            l1 TEXT,
            l2 TEXT,
            l3 TEXT,
            light TEXT,
            temperature TEXT,
            humidity TEXT,
            wind TEXT,
            radiation TEXT,
            noise TEXT,
            electric TEXT,
            owas TEXT,
            question TEXT,
            answer TEXT,
            image TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertResult(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('survey_results', data);
  }

  Future<List<Map<String, dynamic>>> getAllResults() async {
    final db = await database;
    return await db.query('survey_results', orderBy: 'timestamp DESC');
  }

  Future<void> deleteResult(int id) async {
    final db = await database;
    await db.delete('survey_results', where: 'id = ?', whereArgs: [id]);
  }
}