import 'dart:convert';
import 'package:http/http.dart' as http;

class Recipe {
  final String name;
  final String instructions;

  Recipe({required this.name, required this.instructions});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['strMeal'],
      instructions: json['strInstructions'],
    );
  }
}

Future<List<Recipe>> fetchRecipes() async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Chicken'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic>? recipes = data['meals'];
    if (recipes != null) {
      List<Recipe> detailedRecipes = [];
      for (var recipe in recipes) {
        final recipeResponse = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${recipe['idMeal']}'),
        );
        if (recipeResponse.statusCode == 200) {
          final detailedData = json.decode(recipeResponse.body);
          final detailedRecipe = detailedData['meals'][0];
          detailedRecipes.add(Recipe.fromJson(detailedRecipe));
        }
      }
      return detailedRecipes;
    } else {
      print('No recipes found.');
      throw Exception('Failed to load recipes: No recipes found.');
    }
  } else {
    print('Failed to load recipes: ${response.body}');
    throw Exception('Failed to load recipes');
  }
}
