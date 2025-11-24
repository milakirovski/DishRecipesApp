import 'package:flutter/material.dart';
import '../models/dish_model.dart';
import 'dish_card.dart';


class DishGrid extends StatefulWidget {
  final List<Dish> dishes;

  const DishGrid({super.key, required this.dishes});

  @override
  State<StatefulWidget> createState() => _DishGridState();
}

class _DishGridState extends State<DishGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 200/244
      ),
      itemCount: widget.dishes.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return DishCard(dish: widget.dishes[index]);
      },
    );
  }
}
