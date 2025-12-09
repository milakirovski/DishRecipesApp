import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../service/api_service.dart';
import '../screens/favorite_meals_screen.dart';
import '../widgets/favorites_manager.dart';
import '../widgets/meal_grid.dart'; // Assuming you create this screen

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  bool _isSearching = false;

  late List<Meal> _allMeals;
  List<Meal> _visibleMeals = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMealsForCategory();
    // Listen to changes in the global favorites state to refresh the heart icons
    favoritesManager.addListener(_refreshState);
  }

  @override
  void dispose() {
    favoritesManager.removeListener(_refreshState);
    _searchController.dispose();
    super.dispose();
  }

  // Forces a rebuild of the widget when the favorites list changes
  void _refreshState() => setState(() {});

  Future<void> _loadMealsForCategory() async {
    final meals = await _apiService.loadMealsByCategory(widget.category);

    setState(() {
      _allMeals = meals;
      _visibleMeals = meals;
      _isLoading = false;
    });
  }

  Future<void> _onSearchChanged(String query) async {
    final q = query.trim();

    if (q.isEmpty) {
      setState(() {
        _visibleMeals = _allMeals;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await _apiService.searchMealsByName(q);

    // keep only meals that belong to this category
    final filtered = results.where((m) {
      final cat = m.strCategory?.toLowerCase();
      return cat == widget.category.toLowerCase();
    }).toList();

    setState(() {
      _visibleMeals = filtered;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          // Button to navigate to the favorite meals screen
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteMealsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search in ${widget.category}...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 8),

            if (_isSearching) const LinearProgressIndicator(),

            const SizedBox(height: 8),

            // grid with meals
            Expanded(
              child: MealGrid(
                meals: _visibleMeals,
                favoriteMealIds: favoritesManager.favoriteMealIds,
                onToggleFavorite: favoritesManager.toggleFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}