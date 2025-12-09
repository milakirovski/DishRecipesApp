import 'package:dish_recipes_app/models/meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dish_recipes_app/models/category_model.dart';

import '../models/meal_detail_model.dart';

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

  Future<MealDetail?> loadMealDetail(String idMeal) async{
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? meals = data['meals'];

      if (meals == null || meals.isEmpty) {
        return null;
      }

      return MealDetail.fromJson(meals[0] as Map<String, dynamic>);
    } else {
      print('Failed to load meal detail: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> getRandomMealId() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? meals = data['meals'];

      if (meals == null || meals.isEmpty) return null;

      final meal = meals[0] as Map<String, dynamic>;
      return meal['idMeal'] as String;
    } else {
      print('Failed to load random meal: ${response.statusCode}');
      return null;
    }
  }

  Future<Meal?> loadMealById(String idMeal) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'),
    );

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'];

      if (mealsJson == null || mealsJson.isEmpty) {
        return null;
      }

      return Meal.fromJson(mealsJson[0] as Map<String, dynamic>);
    }else{
      print('Failed to load meals by id: ${response.statusCode}');
      return null;
    }
  }
}
