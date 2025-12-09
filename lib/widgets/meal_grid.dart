import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'meal_card.dart';

class MealGrid extends StatelessWidget {
  const MealGrid({
    super.key,
    required this.meals,
    required this.favoriteMealIds,
    required this.onToggleFavorite,
  });

  final List<Meal> meals;
  final Set<String> favoriteMealIds;
  final void Function(String mealId) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const Center(
        child: Text('No meals found for this category or search criteria.'),
      );
    }

    return GridView.builder(
      itemCount: meals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final meal = meals[index];
        final isFavorite = favoriteMealIds.contains(meal.idMeal);

        return MealCard(
          meal: meal,
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        );
      },
    );
  }
}