import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diyet/ui/views/recipe/recipe_results_page.dart';

import '../../../cubit/recipe_cubit.dart';
import '../../../widgets/generic_loading_screen.dart';

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
  double _progress = 0.0;
  Timer? _timer;


  void _submit() async {
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    // Start fake progress animation
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.05;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
        }
      });
    });

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

    // Bekleme bittiğinde progress 1.0 olduysa direkt devam et
    while (_progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 100));
    }


    final recipes = cubit.state.recipes;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeResultsPage(
            recipes: recipes,
            selectedIngredients: widget.selectedIngredients,
            sourcePage: "macros_selection",
          ),
        ),
      );
    }

    _timer?.cancel();
    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: _isLoading
          ? Center(
        child: GenericLoadingScreen(
          progress: _progress,
          title: "Fetching Recipes",
          subtitle: "Analyzing your selected ingredients and finding the best matches...",
          imageAssetPath: "assets/images/salad.png",
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(height: 20,),
             Text(
              "You can optionally enter macro values (g):",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
               textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildMacroField("Enter fat value(g)", _fatController),
            SizedBox(height: 5,),
            _buildMacroField("Enter protein value(g)", _proteinController),
            SizedBox(height: 5,),
            _buildMacroField("Enter carbohydrates value(g)", _carbsController),
            SizedBox(height: 5,),
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
    return Expanded(
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
