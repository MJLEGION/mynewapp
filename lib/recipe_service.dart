// recipe_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Recipe {
  final String id;
  final String name;
  String instructions;
  final String imageUrl;

  Recipe(
      {required this.id,
      required this.name,
      this.instructions = "",
      required this.imageUrl});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      instructions: json['strInstructions'] ?? "",
      imageUrl: json['strMealThumb'],
    );
  }
}

// Fetch basic recipe information
Future<List<Recipe>> fetchBasicRecipes() async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Chicken'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic>? recipes = data['meals'];
    if (recipes != null) {
      return recipes
          .map((recipe) => Recipe(
                id: recipe['idMeal'],
                name: recipe['strMeal'],
                imageUrl: recipe['strMealThumb'], // Include image URL
              ))
          .toList();
    } else {
      throw Exception('No recipes found.');
    }
  } else {
    throw Exception('Failed to load recipes');
  }
}

// Fetch detailed recipe information
Future<Recipe> fetchRecipeDetails(String id) async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
  );

  if (response.statusCode == 200) {
    final detailedData = json.decode(response.body);
    final detailedRecipe = detailedData['meals'][0];
    return Recipe.fromJson(detailedRecipe);
  } else {
    throw Exception('Failed to load recipe details');
  }
}
