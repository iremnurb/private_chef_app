import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'meal_type_selection.dart';


class DolabimdaNeVar extends StatefulWidget {
  const DolabimdaNeVar({super.key});

  @override
  _DolabimdaNeVarState createState() => _DolabimdaNeVarState();
}

class _DolabimdaNeVarState extends State<DolabimdaNeVar> {
  Map<String, List<String>> categorizedIngredients = {};
  final Set<String> selectedIngredients = {};
  final Map<String, String> categoryIcons = {
    "Vegetables": "vegetables.png",
    "Fruits": "fruits.png",
    "Meat & Poultry": "meatandpoultry.png",
    "Dairy & Eggs": "dairyandeggs.png",
    "Organ Meats & Offal": "organmeatsandoffal.png",
    "Seafood": "seafood.png",
    "Grains & Pasta": "grainandpasta.png",
    "Bread & Baked Goods": "breadandbakedgoods.png",
    "Nuts & Seeds": "nutsandseeds.png",
    "Herbs & Spices": "herbsandspices.png",
    "Canned & Jarred": "cannedandjarred.png",
    "Oils & Sauces": "oilsandsauces.png",
    "Sweet & Snacks": "sweetsandsnacks.png",
    "Beverages": "bevereges.png",
    "Additives & Preservatives": "additivitesandpreservatives.png",
  };

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    final String response = await rootBundle.loadString("assets/categorized_ingredients2.json");
    final Map<String, dynamic> data = json.decode(response);
    Map<String, List<String>> groupedData = {};

    data.forEach((ingredient, category) {
      groupedData.putIfAbsent(category, () => []);
      groupedData[category]!.add(ingredient);
    });

    setState(() {
      categorizedIngredients = groupedData;
    });
  }

  void showIngredientsPopup(String category) {
    final allIngredients = categorizedIngredients[category] ?? [];
    List<String> filteredIngredients = List.from(allIngredients)..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final localSelected = Set<String>();
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return AlertDialog(
              title: Text('$category Ingredients'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search ingredient...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setPopupState(() {
                          filteredIngredients = allIngredients
                              .where((ingredient) => ingredient.toLowerCase().contains(value.toLowerCase()))
                              .toList()
                            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: filteredIngredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = filteredIngredients[index];
                            final isChecked = localSelected.contains(ingredient);

                            return CheckboxListTile(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setPopupState(() {
                                  if (value == true) {
                                    localSelected.add(ingredient);
                                  } else {
                                    localSelected.remove(ingredient);
                                  }
                                });
                              },
                              title: Text(ingredient),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIngredients.addAll(localSelected);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("Add Selected", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _goToNextStep() {
    if (selectedIngredients.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealTypeSelectionPage(selectedIngredients: selectedIngredients.toList()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildInfoMessage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                itemCount: categorizedIngredients.keys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 18,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  String category = categorizedIngredients.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () => showIngredientsPopup(category),
                    child: _buildCategoryButton(category),
                  );
                },
              ),
            ),
          ),
          _buildSelectedIngredientChips(),
          const SizedBox(height: 8.0),
          _buildNextButton(),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildSelectedIngredientChips() {
    return Wrap(
      spacing: 6.0,
      children: selectedIngredients.map((ingredient) {
        return Chip(
          label: Text(ingredient),
          deleteIcon: const Icon(Icons.close),
          onDeleted: () {
            setState(() {
              selectedIngredients.remove(ingredient);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryButton(String category) {
    final iconAsset = categoryIcons[category] ?? "salad.png";
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/$iconAsset',
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: selectedIngredients.isEmpty ? null : _goToNextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBF7E04),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Opacity(
          opacity: 1,
          child: Image.asset('assets/images/Rectangle.png'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'What is in your fridge today?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ],
    );
  }


  Widget _buildInfoMessage() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow.shade100,
          border: Border.all(color: Colors.orange.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "The ingredients we assume you already have on hand are: water, salt, and pepper.",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}
