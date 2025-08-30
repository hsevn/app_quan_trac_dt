import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

import '../../data/models/survey_row_data.dart'; // model từng dòng đo

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    _db = await openDatabase(
      join(path, 'quantrac.db'),
      version: 1,
      onCreate: _onCreate,
    );
    return _db!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE survey_row(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        position TEXT,
        light REAL,
        temp REAL,
        humidity REAL
      )
    ''');
  }

  Future<int> insertRow(SurveyRowData row) async {
    final dbClient = await db;
    return await dbClient.insert('survey_row', row.toMap());
  }

  Future<List<SurveyRowData>> getAllRows() async {
    final dbClient = await db;
    final maps = await dbClient.query('survey_row');
    return maps.map((e) => SurveyRowData.fromMap(e)).toList();
  }
}
