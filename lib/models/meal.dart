class Meal {
  String idMeal;
  String strMealThumb;
  String strMeal;
  String? strCategory;

  Meal({
    required this.idMeal,
    required this.strMealThumb,
    required this.strMeal,
    this.strCategory,
  });

  Meal.fromJson(Map<String, dynamic> data)
    : idMeal = data['idMeal'],
      strMealThumb = data['strMealThumb'],
      strMeal = data['strMeal'],
      strCategory = data['strCategory']; // may be null

  Map<String, dynamic> toJson() => {
    'idMeal': idMeal,
    'strMealThumb': strMealThumb,
    'strMeal': strMeal,
    'strCategory': strCategory,
  };
}
