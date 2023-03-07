// ignore: depend_on_referenced_packages
import 'dart:io';

import 'package:guatini/providers/userpreferences_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static final String relativeDbPath = p.join('db', 'db_guatini.db');

  static final DbProvider _instance = DbProvider._();
  DbProvider._();
  factory DbProvider() => _instance;

  Database? _db;

  Future<Database?> get database async {
    if (_db != null) return _db;
    return await initialize();
  }

  Future<bool> open(String path) async {
    final prefs = UserPreferences();
    prefs.dbPath = path;
    return await initialize() != null;
  }

  Future<Database?> initialize() async {
    final prefs = UserPreferences();
    final path = prefs.dbPath;
    final db = p.join(path, DbProvider.relativeDbPath);
    if (!File(db).existsSync()) return null;
    return await openDatabase(
      db,
      version: 1,
      onCreate: (_, __) async {},
    );
  }
}
