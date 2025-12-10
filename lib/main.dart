import 'package:dish_recipes_app/screens/home_screen.dart';
import 'package:dish_recipes_app/screens/meals_by_category_screen.dart';
import 'package:dish_recipes_app/screens/meal_detail_screen.dart';
import 'package:dish_recipes_app/service/firebase_api.dart';
import 'package:flutter/material.dart';

// import of the  Firebase core plugin and the configuration file
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


// // initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dish Recipes App-223182',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Dish Recipes App-223182'),

        // Meals inside a category
        "/mealsByCategory": (context) {
          final category = ModalRoute.of(context)!.settings.arguments as String;
          return MealsByCategoryScreen(category: category);
        },

        // Detailed recipe screen
        "/mealDetails": (context) {
          final mealId = ModalRoute.of(context)!.settings.arguments as String;
          return MealDetailScreen(idMeal: mealId);
        },
      },
    );
  }
}
