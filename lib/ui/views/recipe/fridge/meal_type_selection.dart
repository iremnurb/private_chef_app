import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'max_calories_selection.dart';


class MealTypeSelectionPage extends StatefulWidget {
  final List<String> selectedIngredients;

  const MealTypeSelectionPage({
    super.key,
    required this.selectedIngredients,
  });

  @override
  State<MealTypeSelectionPage> createState() => _MealTypeSelectionPageState();
}

class _MealTypeSelectionPageState extends State<MealTypeSelectionPage> {
  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Dessert'];
  final Set<String> selectedMealTypes = {};

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaxCaloriesSelectionPage(
          selectedIngredients: widget.selectedIngredients,
          selectedMealTypes: selectedMealTypes.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNextEnabled = selectedMealTypes.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFBF7E04),
        title:  Text("Select Meal Type",style: GoogleFonts.poppins(),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "What type of meal are you looking for?",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: mealTypes.length,
                itemBuilder: (context, index) {
                  final meal = mealTypes[index];
                  final isSelected = selectedMealTypes.contains(meal);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected ? selectedMealTypes.remove(meal) : selectedMealTypes.add(meal);
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFBF7E04) : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(meal),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Color(0xFFBF7E04))
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isNextEnabled ? _onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF7E04),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:  Text(
                      "Next",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
