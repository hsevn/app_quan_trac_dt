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
    String path = join(dbPath, 'app_quan_trac_data.sqlite');
    return await openDatabase(path, version: 1);
  }

  Future<List<Map<String, dynamic>>> fetchAreas() async {
    final db = await database;
    return await db.query('area_structure');
  }

  Future<int> insertSurveyResult(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('survey_results', data);
  }

  Future<List<Map<String, dynamic>>> getAllSurveyResults() async {
    final db = await database;
    return await db.query('survey_results');
  }

  Future<int> deleteSurveyResult(int id) async {
    final db = await database;
    return await db.delete('survey_results', where: 'id = ?', whereArgs: [id]);
  }
}
