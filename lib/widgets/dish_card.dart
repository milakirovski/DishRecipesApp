import 'package:flutter/material.dart';
import '../models/dish_model.dart';

class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/details", arguments: dish);
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
                    dish.strCategoryThumb,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 8),

                // TITLE
                Text(
                  dish.strCategory,
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
                      dish.strCategoryDescription,
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
