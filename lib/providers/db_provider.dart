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

  static Database? _db;

  static Future<Database?> get database async {
    if (_db != null) return _db;
    final db = await initialize();
    if (db == null) return Future.error('No database');
    return db;
  }

  static Future<bool> open(String path) async {
    final prefs = UserPreferences();
    prefs.dbPath = path;
    final db = await initialize();
    return db != null;
  }

  static void close() {
    final prefs = UserPreferences();
    prefs.dbPath = '';
    _db = null;
  }

  static bool isOpen() => _db != null;

  static Future<Database?> initialize() async {
    final prefs = UserPreferences();
    final path = prefs.dbPath;
    final db = p.join(path, DbProvider.relativeDbPath);
    if (!File(db).existsSync()) return null;
    try {
      _db = await openDatabase(
        db,
        version: 1,
        onCreate: (_, __) async {},
      );
    } catch (_) {
      //TODO: Arreglar error de que la base de datos no se abre en android 11.
      // Se podra copiar el archivo en la carpeta de la app (en el sistema) y acceder desde ahí ?????
      return null;
    }
    return _db;
  }
}
