import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DAL {
  static final DAL _instance = DAL._internal();
  factory DAL() => _instance;
  DAL._internal();

  static Database? _db;
  static late DatabaseFactory _factory;
  static late String _path;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      _factory = databaseFactoryFfiWeb;
      _path = 'notes.db';
    } else {
      _factory = databaseFactory;
      _path = '${(await getApplicationDocumentsDirectory()).path}notes.db';
    }
    return await _factory.openDatabase(_path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ));
  }

  Future _onCreate(Database db, int version) async {
    // Create your notes table here
    await db.execute('''
        CREATE TABLE classes (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL
        )
      ''');
    await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY,
          classID INTEGER NOT NULL,
          name TEXT NOT NULL,
          content TEXT,
          FOREIGN KEY (classID) REFERENCES classes(id)
        )
      ''');
  }
}
