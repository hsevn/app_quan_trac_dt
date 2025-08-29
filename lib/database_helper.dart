import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_quan_trac_data.sqlite');

    // Copy từ assets nếu chưa có
    final exists = await databaseExists(path);
    if (!exists) {
      ByteData data = await rootBundle.load('assets/app_quan_trac_data.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getAreaStructure() async {
    final db = await database;
    return await db.query('area_structure');
  }
}
