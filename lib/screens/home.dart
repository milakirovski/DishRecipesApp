import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/dish_model.dart';
import '../widgets/dish_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Dish> _dish;               // full list from API
  List<Dish> _filteredDishes = [];     // list shown in the grid
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDishList(n: 20);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by category...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 12),

            // GRID WITH FILTERED DATA
            Expanded(
              child: DishGrid(dishes: _filteredDishes),
            ),
          ],
        ),
      ),
    );
  }

  void _loadDishList({required int n}) async {
    List<Dish> dishList = [];

    final detailResponse = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (detailResponse.statusCode == 200) {
      final detailData = json.decode(detailResponse.body);
      final List<dynamic> categoriesJson = detailData['categories'];

      for (final categoryMap in categoriesJson) {
        dishList.add(Dish.fromJson(categoryMap as Map<String, dynamic>));
      }
    } else {
      print('Failed to load data: ${detailResponse.statusCode}');
    }

    setState(() {
      _dish = dishList;
      _filteredDishes = dishList; // initially show all
      _isLoading = false;
    });
  }

  // FILTER LOCALLY BY CATEGORY NAME
  void _onSearchChanged(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (lowerQuery.isEmpty) {
        _filteredDishes = _dish;
      } else {
        _filteredDishes = _dish
            .where((d) => d.strCategory.toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }
}
