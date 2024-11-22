import 'package:flutter/material.dart';
import 'recipe_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> _recipes;
  final List<Recipe> _selectedRecipes = [];

  @override
  void initState() {
    super.initState();
    _recipes = fetchRecipes();
  }

  void _toggleSelection(Recipe recipe) {
    setState(() {
      if (_selectedRecipes.contains(recipe)) {
        _selectedRecipes.remove(recipe);
      } else {
        _selectedRecipes.add(recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealPlanScreen(selectedRecipes: _selectedRecipes),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Recipe>>(
          future: _recipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No recipes found.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final recipe = snapshot.data![index];
                  final isSelected = _selectedRecipes.contains(recipe);
                  return ListTile(
                    title: Text(recipe.name),
                    trailing: Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isSelected ? Colors.blue : null,
                    ),
                    onTap: () => _toggleSelection(recipe),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

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
          final recipe = selectedRecipes[index];
          return ListTile(
            title: Text(recipe.name),
            subtitle: Text(recipe.instructions),
          );
        },
      ),
    );
  }
}
