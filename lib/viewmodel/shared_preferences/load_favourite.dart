import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadFavourites(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? favouritePackageNames =
      prefs.getStringList('favouritePackages');

  if (favouritePackageNames != null) {}
}
