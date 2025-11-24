import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../service/api_service.dart';

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

  late List<Meal> _allMeals;      // from filter.php?c=
  List<Meal> _visibleMeals = [];  // shown in grid

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMealsForCategory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      //  to original list from category
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            //search bar
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
              child: GridView.builder(
                itemCount: _visibleMeals.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final meal = _visibleMeals[index];

                  return GestureDetector(
                    onTap: () {
                      // if you have a meal details screen:
                      // Navigator.pushNamed(context, '/mealDetails', arguments: meal);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.lightGreen,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.network(
                                meal.strMealThumb,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              meal.strMeal,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
