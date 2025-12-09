// favorite_meals_screen.dart

import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../service/api_service.dart';
import '../widgets/meal_grid.dart';
import '../widgets/favorites_manager.dart';

class FavoriteMealsScreen extends StatefulWidget {
  const FavoriteMealsScreen({super.key});

  @override
  State<FavoriteMealsScreen> createState() => _FavoriteMealsScreenState();
}

class _FavoriteMealsScreenState extends State<FavoriteMealsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Meal> _favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    favoritesManager.addListener(_loadFavoriteMeals);
    _loadFavoriteMeals();
  }

  @override
  void dispose() {
    favoritesManager.removeListener(_loadFavoriteMeals);
    super.dispose();
  }

  Future<void> _loadFavoriteMeals() async {
    setState(() {
      _isLoading = true;
      _favoriteMeals = [];
    });

    final favoriteIds = favoritesManager.favoriteMealIds.toList();
    List<Meal> fetchedMeals = [];

    for (String id in favoriteIds) {
      final meal = await _apiService.loadMealById(id);

      if(meal != null){
        fetchedMeals.add(meal);
      }
    }

    setState(() {
      _favoriteMeals = fetchedMeals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌟 Your Favorite Recipes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: _favoriteMeals.isEmpty
                  ? const Center(
                      child: Text(
                        'You haven\'t added any meals to your favorites yet!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : MealGrid(
                      meals: _favoriteMeals,
                      favoriteMealIds: favoritesManager.favoriteMealIds,
                      // Use the manager's toggle function
                      onToggleFavorite: favoritesManager.toggleFavorite,
                    ),
            ),
    );
  }
}
