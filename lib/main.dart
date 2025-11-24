import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/meal_detail_screen.dart';


void main() {
runApp(const MealDbApp());
}

class MealDbApp extends StatelessWidget {
  const MealDbApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Recipes',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        CategoryScreen.routeName: (context) => const CategoryScreen(),
        MealDetailScreen.routeName: (context) => const MealDetailScreen(),
      },
    );
  }
}