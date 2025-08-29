import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_quan_trac_data.sqlite');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> fetchAreas() async {
    final db = await database;
    return await db.query('area_structure');
  }

  Future<void> insertSurveyResult(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('survey_results', data);
  }

  Future<List<Map<String, dynamic>>> getAllSurveyResults() async {
    final db = await database;
    return await db.query('survey_results', orderBy: 'created_at DESC');
  }

  Future<void> deleteSurveyResult(int id) async {
    final db = await database;
    await db.delete('survey_results', where: 'id = ?', whereArgs: [id]);
  }
}
