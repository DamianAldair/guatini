import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._();
  UserPreferences._();
  factory UserPreferences() => _instance;

  SharedPreferences? _prefs;
  StreamController<String>? _dbPathStreamController;
  StreamController<List<String>>? _databasesStreamController;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _dbPathStreamController = StreamController<String>.broadcast();
    _databasesStreamController = StreamController<List<String>>.broadcast();
  }

  // If the app is opened for the forst time
  final String _keyFirstTime = 'firstTime';

  bool get firstTime => _prefs!.getBool(_keyFirstTime) ?? true;

  set firstTime(bool first) => _prefs!.setBool(_keyFirstTime, first);

  // Path of Database
  final String _keyDbPath = 'dbPath';

  Stream<String> get dbPathStream => _dbPathStreamController!.stream;

  String get dbPath => _prefs!.getString(_keyDbPath) ?? '';

  set dbPath(String? path) {
    if (path == null) {
      throw ArgumentError('Path can not be null');
    }
    _prefs!.setString(_keyDbPath, path);
    _dbPathStreamController!.add(path);
  }

  // Registered databases
  final String _keyDatabases = 'databases';

  List<String> get databases => _prefs!.getStringList(_keyDatabases) ?? [];

  Stream<List<String>> get databasesStream =>
      _databasesStreamController!.stream;

  void newDatabase(String path) {
    List<String> list = databases;
    if (!list.contains(path)) list.add(path);
    _prefs!.setStringList(_keyDatabases, list);
    _databasesStreamController!.add(list);
  }

  void deleteDatabase(String path) {
    List<String> list = databases;
    if (list.contains(path)) list.remove(path);
    _prefs!.setStringList(_keyDatabases, list);
    _databasesStreamController!.add(list);
  }

  // Number of searches to show in search log
  final String _keyNumberOfLastSearches = 'numberOfLastSearches';
  static const int defaultNumberOfLastSearches = 5;

  int get numberOfLastSearches =>
      _prefs!.getInt(_keyNumberOfLastSearches) ?? defaultNumberOfLastSearches;

  set numberOfLastSearches(int number) =>
      _prefs!.setInt(_keyNumberOfLastSearches, number);

  // Searches to show in search log
  final String _keyLastSearches = 'lastSearches';

  List<String> get lastSearches {
    final list = _prefs!.getStringList(_keyLastSearches);
    if (list == null) {
      return [];
    } else {
      final searches = numberOfLastSearches;
      if (list.length > searches) {
        return list.sublist(0, searches);
      } else {
        return list;
      }
    }
  }

  void cleanLastSearches() => _prefs!.setStringList(_keyLastSearches, []);

  void newSearch(String search) {
    List<String> list = lastSearches;
    if (list.contains(search)) {
      list.remove(search);
    }
    list.add(search);
    final searches = numberOfLastSearches;
    if (list.length > searches) {
      list.removeRange(list.length - searches, list.length);
    }
    _prefs!.setStringList(_keyLastSearches, list);
  }

  final String _keySeggestions = 'suggestions';
  static const int defaultNumberOfSeggestions = 5;

  int get suggestions =>
      _prefs!.getInt(_keySeggestions) ?? defaultNumberOfSeggestions;

  set suggestions(int number) => _prefs!.setInt(_keySeggestions, number);

  // If headset is connected or not
  final String _keyOnlyHeadset = 'onlyHeadset';

  bool get onlyHeadset => _prefs!.getBool(_keyOnlyHeadset) ?? false;

  set onlyHeadset(bool only) => _prefs!.setBool(_keyOnlyHeadset, only);

  // Current locale of app
  final String _keyLocale = 'locale';

  Locale? get locale {
    final l = _prefs!.getString(_keyLocale);
    if (l == null) return null;
    return Locale(l);
  }

  set locale(Locale? locale) {
    if (locale == null) {
      throw ArgumentError('Locale can not be null');
    }
    _prefs!.setString(_keyLocale, locale.languageCode);
  }
}
