import 'package:dish_recipes_app/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dish Recipes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Dish Recipes App'),
        // "/details": (context) => const DetailsPage(),
      },
    );
  }
}
