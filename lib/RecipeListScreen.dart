import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'recipe_service.dart';
import 'FavouriteScreen.dart';
import 'RecipeDetailScreen.dart';
import 'theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Recipe App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.currentTheme,
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> _futureRecipes;
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _futureRecipes = fetchBasicRecipes();
    _futureRecipes.then((recipes) {
      setState(() {
        _recipes = recipes;
      });
    });
  }

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      if (_favoriteRecipes.contains(recipe)) {
        _favoriteRecipes.remove(recipe);
      } else {
        _favoriteRecipes.add(recipe);
      }
    });
  }

  void _showDetails(String id) async {
    final detailedRecipe = await fetchRecipeDetails(id);
    setState(() {
      final index = _recipes.indexWhere((recipe) => recipe.id == id);
      _recipes[index] = detailedRecipe;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: detailedRecipe),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeNotifier.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: _recipes.isEmpty
            ? FutureBuilder<List<Recipe>>(
                future: _futureRecipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No recipes found.');
                  } else {
                    return _buildRecipeGrid(snapshot.data!);
                  }
                },
              )
            : _buildRecipeGrid(_recipes),
      ),
    );
  }

  Widget _buildRecipeGrid(List<Recipe> recipes) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index