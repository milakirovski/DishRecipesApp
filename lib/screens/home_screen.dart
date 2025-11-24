import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../service/api_service.dart';
import '../widgets/category_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Category> _categories;               // full list from API
  List<Category> _filteredCategories = [];     // list shown in the grid
  bool _isLoading = true;
  final ApiService _api_service = ApiService();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDishList();
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
              child: CategoryGrid(categories: _filteredCategories),
            ),
          ],
        ),
      ),
    );
  }

  void _loadDishList() async {

    final categoryList = await _api_service.loadCategoryList();

    setState(() {
      _categories = categoryList;
      _filteredCategories = categoryList; // initially show all
      _isLoading = false;
    });
  }

  // FILTER LOCALLY BY CATEGORY NAME
  void _onSearchChanged(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (lowerQuery.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where((d) => d.strCategory.toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }
}
