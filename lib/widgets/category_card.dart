import 'package:dish_recipes_app/screens/meals_by_category_screen.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       Navigator.push(context, MaterialPageRoute(builder: (_) => MealsByCategoryScreen(category: category.strCategory)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.lightGreen, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 260,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    category.strCategoryThumb,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 8),

                // TITLE
                Text(
                  category.strCategory,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // DESCRIPTION, takes all remaining space and scrolls if too long
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      category.strCategoryDescription,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
