import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  bool isSetttingsSelected = false;
  bool isFavouriteSelected = false;
  bool isSearchSelected = false;

  void toggleSearch() {
    isSearchSelected = !isSearchSelected;
    isFavouriteSelected = false;
    isSetttingsSelected = false;
    notifyListeners();
  }

  void toggleFavourite() {
    isFavouriteSelected = !isFavouriteSelected;
    isSearchSelected = false;
    isSetttingsSelected = false;
    notifyListeners();
  }

  void toggleSettings() {
    isFavouriteSelected = false;
    isSearchSelected = false;
    isSetttingsSelected = !isSetttingsSelected;
    notifyListeners();
  }

  void setSelectedIndex(int index) {}
}
