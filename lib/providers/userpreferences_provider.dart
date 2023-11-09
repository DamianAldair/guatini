import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:guatini/models/game_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._();
  UserPreferences._();
  factory UserPreferences() => _instance;

  SharedPreferences? _prefs;
  final dbPathNotifier = ValueNotifier<String?>(null);
  final databasesNotifier = ValueNotifier<List<String>>([]);
  StreamController<List<GameModel>>? _gamesStreamController;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    dbPathNotifier.value = _prefs?.getString(_keyDbPath);
    databasesNotifier.value = _prefs?.getStringList(_keyDatabases) ?? [];
    _gamesStreamController = StreamController<List<GameModel>>.broadcast();
  }

  // If the app is opened for the forst time
  final String _keyFirstTime = 'firstTime';

  bool get firstTime => _prefs!.getBool(_keyFirstTime) ?? true;

  set firstTime(bool first) => _prefs!.setBool(_keyFirstTime, first);

  // Path of Database
  final String _keyDbPath = 'dbPath';

  set dbPath(String? path) {
    if (path == null) {
      _prefs!.remove(_keyDbPath);
      dbPathNotifier.value = null;
    } else {
      _prefs!.setString(_keyDbPath, path);
      dbPathNotifier.value = path;
    }
  }

  // Registered databases
  final String _keyDatabases = 'databases';

  void newDatabase(String path) {
    List<String> list = databasesNotifier.value;
    if (!list.contains(path)) list.add(path);
    _prefs!.setStringList(_keyDatabases, list);
    databasesNotifier.value = list;
  }

  void deleteDatabase(String path) {
    List<String> list = databasesNotifier.value;
    if (list.contains(path)) list.remove(path);
    _prefs!.setStringList(_keyDatabases, list);
    databasesNotifier.value = list;
  }

  // Number of searches to show in search log
  final String _keyNumberOfLastSearches = 'numberOfLastSearches';

  int get numberOfLastSearches => _prefs!.getInt(_keyNumberOfLastSearches) ?? 5;

  set numberOfLastSearches(int number) => _prefs!.setInt(_keyNumberOfLastSearches, number);

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

  int get suggestions => _prefs!.getInt(_keySeggestions) ?? defaultNumberOfSeggestions;

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

  // Online Use
  final String _keyWikipediaOnline = 'wikipediaOnline';

  bool get wikipediaOnline => _prefs!.getBool(_keyWikipediaOnline) ?? true;

  set wikipediaOnline(bool online) => _prefs!.setBool(_keyWikipediaOnline, online);

  final String _keyImageOnline = 'imageOnline';

  // bool get imageOnline => _prefs!.getBool(_keyImageOnline) ?? true;
  bool get imageOnline => _prefs!.getBool(_keyImageOnline) ?? false;

  set imageOnline(bool online) => _prefs!.setBool(_keyImageOnline, online);

  final String _keyAudioOnline = 'audioOnline';

  bool get audioOnline => _prefs!.getBool(_keyAudioOnline) ?? true;

  set audioOnline(bool online) => _prefs!.setBool(_keyAudioOnline, online);

  final String _keyVideoOnline = 'videoOnline';

  bool get videoOnline => _prefs!.getBool(_keyVideoOnline) ?? true;

  set videoOnline(bool online) => _prefs!.setBool(_keyVideoOnline, online);

  final String _keyOpenWeb = 'openWeb';

  bool get openWeb => _prefs!.getBool(_keyOpenWeb) ?? true;

  set openWeb(bool online) => _prefs!.setBool(_keyOpenWeb, online);

  // Auto play
  final String _keyAutoplayAudio = 'autoplayAudio';

  bool get autoplayAudio => _prefs!.getBool(_keyAutoplayAudio) ?? false;

  set autoplayAudio(bool autoplay) => _prefs!.setBool(_keyAutoplayAudio, autoplay);

  final String _keyAutoplayVideo = 'autoplayVideo';

  bool get autoplayVideo => _prefs!.getBool(_keyAutoplayVideo) ?? false;

  set autoplayVideo(bool autoplay) => _prefs!.setBool(_keyAutoplayVideo, autoplay);

  // Games
  final String _keyGames = 'games';

  List<GameModel> get games {
    final temp = _prefs!.getStringList(_keyGames) ?? [];
    final list = <GameModel>[];
    for (String s in temp) {
      list.add(GameModel.fromJson(json.decode(s)));
    }
    return list;
  }

  void addGame(GameModel game) {
    final strings = <String>[];
    final list = games;
    if (!list.any((e) => e.id == game.id)) {
      list.add(game);
      for (GameModel g in list) {
        strings.add(json.encode(g.toJson()));
      }
      _prefs!.setStringList(_keyGames, strings).then((_) => _gamesStreamController!.add(list));
    }
  }

  void updateGame(GameModel game) {
    final strings = <String>[];
    final list = games;
    list.removeWhere((e) => e.id == game.id);
    list.add(game);
    for (GameModel g in list) {
      strings.add(json.encode(g.toJson()));
    }
    _prefs!.setStringList(_keyGames, strings).then((_) => _gamesStreamController!.add(list));
  }

  Stream<List<GameModel>> get gamesStream => _gamesStreamController!.stream;
}
