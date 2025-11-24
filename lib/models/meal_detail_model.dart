class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final String? strYoutube;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    required this.strYoutube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> data) {
    final ingredients = <Ingredient>[];

    for (int i = 1; i <= 20; i++) {
      final ing = data['strIngredient$i'];
      final meas = data['strMeasure$i'];

      if (ing != null &&
          ing.toString().trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ing.toString().trim(),
            measure: (meas ?? '').toString().trim(),
          ),
        );
      }
    }

    return MealDetail(
      idMeal: data['idMeal'],
      strMeal: data['strMeal'],
      strMealThumb: data['strMealThumb'],
      strInstructions: data['strInstructions'] ?? '',
      strYoutube: data['strYoutube'],
      ingredients: ingredients,
    );
  }
}
