import 'package:flutter/material.dart';
import 'recipe_service.dart'; // Make sure to import the Recipe class

class MealPlanScreen extends StatelessWidget {
  final List<Recipe> selectedRecipes;

  MealPlanScreen({required this.selectedRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan'),
      ),
      body: ListView.builder(
        itemCount: selectedRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(selectedRecipes[index].name),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'recipe_service.dart'; // Make sure to import the Recipe class

class MealPlanScreen extends StatelessWidget {
  final List<Recipe> selectedRecipes;

  MealPlanScreen({required this.selectedRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan'),
      ),
      body: ListView.builder(
        itemCount: selectedRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(selectedRecipes[index].name),
          );
        },
      ),
    );
  }
}
