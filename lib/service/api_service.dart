import 'package:dish_recipes_app/models/meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dish_recipes_app/models/category_model.dart';

class ApiService {

  Future<List<Category>> loadCategoryList() async {
    List<Category> allCategories = [];

    final detailResponse = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (detailResponse.statusCode == 200) {
      final detailData = json.decode(detailResponse.body);
      final List<dynamic> categoriesJson = detailData['categories'];

      for (final categoryMap in categoriesJson) {
        allCategories.add(
          Category.fromJson(categoryMap as Map<String, dynamic>),
        );
      }
    } else {
      print('Failed to load data: ${detailResponse.statusCode}');
    }

   return allCategories;
  }

  Future<List<Meal>> loadMealsByCategory(String category) async{
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
    );

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'];

      if (mealsJson == null) return [];

      return mealsJson
          .map((m) => Meal.fromJson(m as Map<String, dynamic>))
          .toList();
    }else{
      print('Failed to load meals by category: ${response.statusCode}');
      return [];
    }
  }

  Future<List<Meal>> searchMealsByName(String query) async{
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'];

      if (mealsJson == null) return [];

      return mealsJson
          .map((m) => Meal.fromJson(m as Map<String, dynamic>))
          .toList();
    } else {
      print('Failed to search meals: ${response.statusCode}');
      return [];
    }
  }
}
