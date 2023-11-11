import 'package:flutter/material.dart';
import 'package:guatini/models/ad_model.dart';
import 'package:guatini/providers/userpreferences_provider.dart';

abstract class AdsProvider {
  static BuildContext? context;
  static int _counter = 0;
  static List<AdModel> _ads = <AdModel>[];

  static void incrementCounter() => _counter++;

  static bool get show => _counter % 1 == 0;

  static set ads(List<AdModel> list) => _ads = list;

  static AdModel? get nextAd {
    if (_ads.isEmpty) return null;
    final prefs = UserPreferences();
    final lastAdId = prefs.lastAdId;
    final ad = _ads.firstWhere((model) => model.id > lastAdId, orElse: () => _ads.first);
    prefs.lastAdId = ad.id;
    return ad;
  }
}
