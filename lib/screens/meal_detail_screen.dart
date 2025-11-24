import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal_detail_model.dart';
import '../service/api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String idMeal;

  const MealDetailScreen({super.key, required this.idMeal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  MealDetail? _mealDetail;

  @override
  void initState() {
    super.initState();
    _loadMealDetail();
  }

  Future<void> _loadMealDetail() async {
    final detail = await _apiService.loadMealDetail(widget.idMeal);

    setState(() {
      _mealDetail = detail;
      _isLoading = false;
    });
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url.trim());

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,        // works for mobile + web
      webOnlyWindowName: '_blank',            // open new tab on web
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open YouTube link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mealDetail?.strMeal ?? 'Recipe'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mealDetail == null
          ? const Center(child: Text('Recipe not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _mealDetail!.strMealThumb,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // NAME
            Text(
              _mealDetail!.strMeal,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // INGREDIENTS
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ..._mealDetail!.ingredients.map(
                  (ing) => Text('• ${ing.measure} ${ing.name}'),
            ),

            const SizedBox(height: 16),

            // INSTRUCTIONS
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _mealDetail!.strInstructions,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),

            const SizedBox(height: 16),

            // YOUTUBE LINK (if available)
            if (_mealDetail!.strYoutube != null &&
                _mealDetail!.strYoutube!.trim().isNotEmpty)
              ElevatedButton.icon(
                onPressed: () =>
                    _launchYouTube(_mealDetail!.strYoutube!),
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
