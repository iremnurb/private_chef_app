import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/entity/recipe_model.dart';
import '../diyet/ogun_detay_sayfa.dart';

class RecipeListByCategoryPage extends StatefulWidget {
  final String title;
  final List<RecipeModel> recipes;

  const RecipeListByCategoryPage({
    super.key,
    required this.title,
    required this.recipes,
  });

  @override
  State<RecipeListByCategoryPage> createState() => RecipeListByCategoryPageState();
}

class RecipeListByCategoryPageState extends State<RecipeListByCategoryPage> {
  late List<RecipeModel> filtered;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtered = widget.recipes;
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    setState(() {
      filtered = widget.recipes.where((recipe) {
        final nameMatch = recipe.name.toLowerCase().contains(q);
        final ingredientsMatch = recipe.recipeIngredientParts.toLowerCase().contains(q);
        return nameMatch || ingredientsMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFBF7E04),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Search by recipe or ingredient...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final recipe = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Prep: ${recipe.prepTime ?? '-'} | Cook: ${recipe.cookTime ?? '-'} | Total: ${recipe.totalTime ?? '-'}",
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _showDetails(context, recipe);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFBF7E04), width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child:  Text("Missing Ingredients", style: GoogleFonts.poppins(color: Color(0xFFBF7E04), textStyle: TextStyle(fontSize: 13))),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OgunDetaySayfa(mealId: recipe.id,themeColor: Color(0xFFBF7E04),),
                                    ),
                                  );
                                },
                               style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFBF7E04), width: 2),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),

                                child:  Text("Show Details", style: GoogleFonts.poppins(color: Color(0xFFBF7E04),textStyle: TextStyle(fontSize: 13))),
                              ),
                            ),
                          ],
                        ),
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

  void _showDetails(BuildContext context, RecipeModel recipe) {
    final ingredients = recipe.recipeIngredientParts.split(',').map((e) => e.trim()).toList();
    final missing = recipe.missingIngredients ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              //const Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              //Text(recipe.recipeInstructions ?? "-", style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
               Text("Ingredients:", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              ...ingredients.map((i) => ListTile(
                title: Text(i),
                leading: missing.map((e) => e.toLowerCase()).contains(i.toLowerCase())
                    ? const Icon(Icons.cancel, color: Colors.red)
                    : const Icon(Icons.check_circle, color: Colors.green),
              )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBF7E04),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child:  Text("Close",style: GoogleFonts.poppins(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}