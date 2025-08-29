import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> openAndCloseDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'app_quan_trac_data.sqlite');
  final db = await openDatabase(path); // chỉ mở, không query
  await db.close();
  return path;
}
