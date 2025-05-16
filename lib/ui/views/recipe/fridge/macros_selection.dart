import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diyet/ui/views/recipe/recipe_results_page.dart';

import '../../../cubit/recipe_cubit.dart';

class MacrosSelectionPage extends StatefulWidget {
  final List<String> selectedIngredients;
  final List<String> selectedMealTypes;
  final int maxCalories;

  const MacrosSelectionPage({
    super.key,
    required this.selectedIngredients,
    required this.selectedMealTypes,
    required this.maxCalories,
  });

  @override
  State<MacrosSelectionPage> createState() => _MacrosSelectionPageState();
}

class _MacrosSelectionPageState extends State<MacrosSelectionPage> {
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    setState(() => _isLoading = true);

    final fat = double.tryParse(_fatController.text);
    final protein = double.tryParse(_proteinController.text);
    final carbs = double.tryParse(_carbsController.text);
    final sugar = double.tryParse(_sugarController.text);

    final cubit = context.read<RecipeCubit>();
    await cubit.fetchRecipesWithAdvancedFilter(
      ingredients: widget.selectedIngredients,
      mealType: widget.selectedMealTypes,
      maxCalories: widget.maxCalories,
      fat: fat,
      protein: protein,
      carbs: carbs,
      sugar: sugar,
    );

    final recipes = cubit.state.recipes;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeResultsPage(
            recipes: recipes,
            selectedIngredients: widget.selectedIngredients,
          ),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Macros",style: GoogleFonts.poppins(),),
        backgroundColor: const Color(0xFFBF7E04),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
             Text(
              "You can optionally enter macro values (g):",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
               textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildMacroField("Enter fat value(g)", _fatController),
            _buildMacroField("Enter protein value(g)", _proteinController),
            _buildMacroField("Enter carbohydrates value(g)", _carbsController),
            _buildMacroField("Enter sugar value(g)", _sugarController),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF7E04),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:  Text("Next",style: GoogleFonts.poppins(color: Colors.white),),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _submit,
              child:  Text("Skip", style: GoogleFonts.poppins(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
