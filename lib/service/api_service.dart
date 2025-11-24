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
}
