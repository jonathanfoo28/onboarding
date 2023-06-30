import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

class FavouriteProvider extends ChangeNotifier {
  List<String> _favoritePackageNames = [];
  late SharedPreferences prefs;

  List<String> get favourtiePackage => _favoritePackageNames;

  FavouriteProvider() {
    loadFavoritePackages();
  }

  Future<void> loadFavoritePackages() async {
    prefs = await SharedPreferences.getInstance();
    _favoritePackageNames = prefs.getStringList('favoritePackages') ?? [];
    notifyListeners();
  }

  bool isPackageFavorited(String packageName) {
    return _favoritePackageNames.contains(packageName);
  }

  Future<void> toggleFavourite(String packageName) async {
    if (isPackageFavorited(packageName)) {
      _favoritePackageNames.remove(packageName);
    } else {
      _favoritePackageNames.add(packageName);
    }

    await prefs.setStringList('favoritePackages', _favoritePackageNames);
    notifyListeners();
  }
}
