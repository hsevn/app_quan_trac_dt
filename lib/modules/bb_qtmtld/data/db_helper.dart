import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'app_quan_trac_data.sqlite');
    _db = await openDatabase(path);
    return _db!;
  }

  Future<List<Map<String, dynamic>>> getL1Areas() async {
    final db = await database;
    return db.rawQuery('SELECT DISTINCT L1_CODE, L1_NAME FROM area_structure');
  }

  Future<List<Map<String, dynamic>>> getL2Areas(String l1Code) async {
    final db = await database;
    return db.rawQuery('SELECT DISTINCT L2_CODE, L2_NAME FROM area_structure WHERE L1_CODE = ?', [l1Code]);
  }

  Future<List<Map<String, dynamic>>> getL3Areas(String l1Code, String l2Code) async {
    final db = await database;
    return db.rawQuery('SELECT L3_CODE, L3_NAME FROM area_structure WHERE L1_CODE = ? AND L2_CODE = ?', [l1Code, l2Code]);
  }

  Future<int> insertResult(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('survey_results', data);
  }

  Future<List<Map<String, dynamic>>> getAllResults() async {
    final db = await database;
    return db.query('survey_results');
  }

  Future<int> deleteResult(int id) async {
    final db = await database;
    return db.delete('survey_results', where: 'id = ?', whereArgs: [id]);
  }
}
