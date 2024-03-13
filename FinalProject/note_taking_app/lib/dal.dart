import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DAL {
  static final DAL _instance = DAL._internal();
  factory DAL() => _instance;
  DAL._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}notes.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create your notes table here
    await db.execute('''
        CREATE TABLE classes (
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');
    await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY,
          class TEXT NOT NULL,
          note TEXT,
          FOREIGN KEY (class) REFERENCES classes (name)
        )
      ''');
  }
}
