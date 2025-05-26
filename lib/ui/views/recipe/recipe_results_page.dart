
import 'package:diyet/data/entity/recipe_model.dart';
import 'package:diyet/ui/views/recipe/recipe_list_by_category_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeResultsPage extends StatefulWidget {
  final List<RecipeModel> recipes;
  final List<String> selectedIngredients;
  final List<String>? selectedMealTypes;
  final String sourcePage;
  final List<String>? includeIngredients;
  final List<String>? excludeIngredients;
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
    required this.sourcePage,
    this.includeIngredients,
    this.excludeIngredients,
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



  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMealType(widget.recipes);
    final totalRecipes = widget.recipes.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Recipes"),
        titleTextStyle: GoogleFonts.poppins(fontSize: 25,color: Colors.black, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: widget.recipes.isEmpty
          ? const Center(child: Text("No recipes found for the given filters."))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDynamicHeader(totalRecipes),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final mealType = grouped.keys.elementAt(index);
                final list = grouped[mealType]!;
                final iconPath = 'assets/images/${mealIcons[mealType] ?? "default.png"}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeListByCategoryPage(
                          title: mealType,
                          recipes: list,
                          sourcePage: widget.sourcePage,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(iconPath, width: 50, height: 50),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mealType,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${list.length} recipes available",
                                style: GoogleFonts.poppins(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicHeader(int totalRecipes) {
    if (widget.sourcePage == "time_limits") {
      final includes = widget.includeIngredients ?? [];
      final excludes = widget.excludeIngredients ?? [];

      List<TextSpan> spanList = [
        const TextSpan(text: "Here you can find recipes "),
      ];

      if (includes.isNotEmpty) {
        spanList.add(const TextSpan(text: "with "));
        spanList.addAll(includes.map((ing) => TextSpan(
          text: "$ing, ",
          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        )));
      }

      if (excludes.isNotEmpty) {
        spanList.add(const TextSpan(text: "and without "));
        spanList.addAll(excludes.map((ing) => TextSpan(
          text: "$ing, ",
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        )));
      }

      if (spanList.isNotEmpty && spanList.last.text!.endsWith(', ')) {
        spanList[spanList.length - 1] = TextSpan(
          text: spanList.last.text!.replaceAll(RegExp(r',\s*$'), ''),
          style: spanList.last.style,
        );
      }

      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          children: spanList,
        ),
      );
    } else {
      final ingredientList = widget.selectedIngredients.take(totalRecipes).toList();
      return Text.rich(
        TextSpan(
          text: "We have $totalRecipes recipes for you with ",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          children: [
            for (int i = 0; i < ingredientList.length; i++) ...[
              TextSpan(
                text: ingredientList[i],
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              if (i < ingredientList.length - 1) const TextSpan(text: ", "),
            ]
          ],
        ),
      );
    }
  }

  Map<String, List<RecipeModel>> _groupByMealType(List<RecipeModel> recipes) {
    final grouped = <String, List<RecipeModel>>{};
    for (var recipe in recipes) {
      final mealType = recipe.mealType.trim() ?? "Unknown";
      grouped.putIfAbsent(mealType, () => []).add(recipe);
    }
    return grouped;
  }
}
