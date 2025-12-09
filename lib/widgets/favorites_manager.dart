// favorites_manager.dart

import 'package:flutter/material.dart';

class FavoritesManager extends ChangeNotifier {
  final Set<String> _favoriteMealIds = {};

  Set<String> get favoriteMealIds => _favoriteMealIds;

  bool isFavorite(String mealId) {
    return _favoriteMealIds.contains(mealId);
  }

  void toggleFavorite(String mealId) {
    if (_favoriteMealIds.contains(mealId)) {
      _favoriteMealIds.remove(mealId);
    } else {
      _favoriteMealIds.add(mealId);
    }
    notifyListeners();
  }
}

final favoritesManager = FavoritesManager();