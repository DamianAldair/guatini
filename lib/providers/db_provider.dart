import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:guatini/models/sql_table_model.dart';
import 'package:guatini/providers/ads_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static final String relativeDbPath = p.join('guatini.db');

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

  static Future<void> close() async {
    final prefs = UserPreferences();
    prefs.dbPath = null;
    await _db?.close();
    AdsProvider.ads = [];
    _db = null;
  }

  static bool isOpen() => _db != null;

  static Future<Database?> initialize() async {
    final prefs = UserPreferences();
    final path = prefs.dbPathNotifier.value;
    if (path == null) return null;
    final db = p.join(path, relativeDbPath);
    if (!File(db).existsSync()) return null;
    try {
      _db = await openDatabase(
        db,
        version: 1,
        onCreate: (_, __) async {},
      );
      if (_db != null) {
        AdsProvider.ads = await SearchProvider.getAds(_db!);
      }
    } catch (_) {
      return null;
    }
    return _db;
  }

  /// Return:
  ///  - null: Problems to access to DB.
  ///  - false: DB schema is not correct.
  ///  - true: DB schema is correct.
  static Future<bool?> check(String folderPath) async {
    final dbPath = p.join(folderPath, relativeDbPath);
    if (!await File(dbPath).exists()) return null;
    try {
      final db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (_, __) async {},
      );
      final templatesJson = json.decode(await rootBundle.loadString('assets/res/tables_scheme.json'));
      final templates = templatesJson.map((map) => SqlTableModel.fromMap(map)).toList();
      final tables = await SearchProvider.getTables(db);
      final correct = templates.every((t) => tables.contains(t));
      await db.close();
      return correct;
    } catch (_) {
      return null;
    }
  }
}
