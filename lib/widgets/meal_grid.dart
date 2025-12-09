import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'meal_card.dart';

class MealGrid extends StatelessWidget {
  const MealGrid({
    super.key,
    required this.meals
  });

  final List<Meal> meals;

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

        return MealCard(
          meal: meal,
        );
      },
    );
  }
}