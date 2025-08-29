import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  DBHelper._internal() {
    // Bắt buộc cho Desktop (Linux/Windows/Mac) khi dùng sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  static final DBHelper instance = DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    final dbDir = await databaseFactory.getDatabasesPath();
    final dbPath = join(dbDir, 'app_quan_trac_data.sqlite');

    // Nếu chưa có file DB ở đường dẫn của sqflite -> copy từ assets
    final file = File(dbPath);
    if (!await file.exists()) {
      await _copyAssetDbTo(dbPath);
    }

    _db = await databaseFactory.openDatabase(dbPath);
    // Đảm bảo bảng kết quả tồn tại (nếu DB asset chưa có)
    await _createSurveyResultsIfNeeded(_db!);
    return _db!;
  }

  Future<void> _copyAssetDbTo(String dstPath) async {
    // Đọc file trong assets
    final data = await rootBundle.load('assets/app_quan_trac_data.sqlite');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Tạo thư mục nếu chưa có
    final dstFile = File(dstPath);
    await dstFile.parent.create(recursive: true);

    // Ghi file
    await dstFile.writeAsBytes(bytes, flush: true);
  }

  Future<void> _createSurveyResultsIfNeeded(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS survey_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        l1_code TEXT,
        l2_code TEXT,
        l3_code TEXT,
        custom_name TEXT,
        parameter TEXT,
        value TEXT,
        created_at TEXT
      );
    ''');
  }

  // ============ APIs ============

  Future<List<Map<String, dynamic>>> fetchAreas() async {
    final db = await database;
    final rows = await db.query('area_structure');
    return rows;
  }

  Future<void> insertSurveyResult(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('survey_results', data);
  }

  Future<List<Map<String, dynamic>>> getAllSurveyResults() async {
    final db = await database;
    return db.query('survey_results', orderBy: 'created_at DESC');
  }

  Future<void> deleteSurveyResult(int id) async {
    final db = await database;
    await db.delete('survey_results', where: 'id = ?', whereArgs: [id]);
  }
}
