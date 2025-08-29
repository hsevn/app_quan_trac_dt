import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'ffi_db_smoke_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  String msg = 'HELLO (about to open DB)';
  try {
    final path = await openAndCloseDb();
    msg = 'DB opened & closed OK at:\n$path';
  } catch (e, s) {
    msg = 'DB open failed:\n$e';
    // print(s); // nếu cần xem stack
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: Text(msg, textAlign: TextAlign.center)),
    ),
  ));
}
