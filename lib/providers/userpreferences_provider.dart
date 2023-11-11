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
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    databasesNotifier.notifyListeners();
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

  set numberOfLastSearches(int number) {
    if (number < 5 || number > 20) return;
    _prefs!.setInt(_keyNumberOfLastSearches, number);
  }

  // Searches to show in search log
  final String _keyLastSearches = 'lastSearches';

  List<String> get lastSearches {
    List<String> list = _prefs!.getStringList(_keyLastSearches) ?? [];
    if (list.length > numberOfLastSearches) {
      list = list.reversed.toList();
      list = list.sublist(0, numberOfLastSearches);
      list = list.reversed.toList();
    }
    _prefs!.setStringList(_keyLastSearches, list);
    return list;
  }

  void cleanLastSearches() => _prefs!.setStringList(_keyLastSearches, []);

  void newSearch(String search) {
    List<String> list = lastSearches;
    final s = search.trim().toLowerCase();
    if (list.contains(s)) {
      list.remove(s);
    }
    list.add(s);
    if (list.length > numberOfLastSearches) {
      list = list.reversed.toList();
      list = list.sublist(0, numberOfLastSearches);
      list = list.reversed.toList();
    }
    _prefs!.setStringList(_keyLastSearches, list);
  }

  final String _keySeggestions = 'suggestions';
  static const int defaultNumberOfSeggestions = 5;

  int get suggestions => _prefs!.getInt(_keySeggestions) ?? defaultNumberOfSeggestions;

  set suggestions(int number) {
    if (number < 3 || number > 10) return;
    _prefs!.setInt(_keySeggestions, number).then((_) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      dbPathNotifier.notifyListeners();
    });
  }

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

  final String _keyEcuredOnline = 'ecuredOnline';

  bool get ecuredOnline => _prefs!.getBool(_keyEcuredOnline) ?? true;

  set ecuredOnline(bool online) => _prefs!.setBool(_keyEcuredOnline, online);

  final String _keyExternalBrowser = 'externalBrowser';

  bool get externalBrowser => _prefs!.getBool(_keyExternalBrowser) ?? false;

  set externalBrowser(bool online) => _prefs!.setBool(_keyExternalBrowser, online);

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

  //ADS
  final String _keyShowAds = 'showAds';

  bool get showAds => _prefs!.getBool(_keyShowAds) ?? true;

  set showAds(bool show) => _prefs!.setBool(_keyShowAds, show);

  final String _keyLastAdId = 'lastAdId';

  int get lastAdId => _prefs!.getInt(_keyLastAdId) ?? -1;

  set lastAdId(int lastId) => _prefs!.setInt(_keyLastAdId, lastId);
}
