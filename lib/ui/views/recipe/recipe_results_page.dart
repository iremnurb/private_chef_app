import 'package:diyet/data/entity/recipe_model.dart';
import 'package:diyet/ui/views/recipe/recipe_list_by_category_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeResultsPage extends StatefulWidget {
  final List<RecipeModel> recipes;
  final List<String> selectedIngredients;
  final List<String>? selectedMealTypes;
  final int? maxCalories;
  final double? fat;
  final double? protein;
  final double? carbs;
  final double? sugar;

  const RecipeResultsPage({
    super.key,
    required this.recipes,
    required this.selectedIngredients,
    this.selectedMealTypes,
    this.maxCalories,
    this.fat,
    this.protein,
    this.carbs,
    this.sugar,
  });

  @override
  State<RecipeResultsPage> createState() => _RecipeResultsPageState();
}

class _RecipeResultsPageState extends State<RecipeResultsPage> {
  final Map<String, String> mealIcons = {
    'Breakfast': 'Breakfast.png',
    'Lunch': 'Lunch.png',
    'Dinner': 'Dinner.png',
    'Snack': 'Snack.png',
    'Dessert': 'Dessert.png',
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMealType(widget.recipes);
    final totalRecipes = widget.recipes.length;
    final ingredientList = widget.selectedIngredients.take(totalRecipes).join(", ");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text("Recipe Results", style: GoogleFonts.poppins(),),
        backgroundColor: const Color(0xFFBF7E04),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFBF7E04)))
          : widget.recipes.isEmpty

          ? const Center(child: Text("No recipes found for the given filters."))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "We have $totalRecipes recipes for you with $ingredientList ingredients !",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...grouped.entries.map((entry) {
            final mealType = entry.key;
            final list = entry.value;
            final iconPath = 'assets/images/${mealIcons[mealType] ?? "default.png"}';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeListByCategoryPage(
                      title: mealType,
                      recipes: list,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: const Color(0xFFF4F4F4),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Image.asset(
                        iconPath,
                        height: 50,
                        width: 50,
                        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mealType,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${list.length} recipes available",
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Map<String, List<RecipeModel>> _groupByMealType(List<RecipeModel> recipes) {
    final grouped = <String, List<RecipeModel>>{};
    for (var recipe in recipes) {
      final mealType = recipe.mealType?.trim() ?? "Unknown";
      grouped.putIfAbsent(mealType, () => []).add(recipe);
    }
    return grouped;
  }
}
