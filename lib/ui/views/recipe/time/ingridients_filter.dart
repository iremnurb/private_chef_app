import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../cubit/recipe_cubit.dart';
import '../recipe_results_page.dart';


class IngredientFilterPage extends StatefulWidget {
  final int cookMinutes;
  final int prepMinutes;
  final int totalMinutes;

  const IngredientFilterPage({
    super.key,
    required this.cookMinutes,
    required this.prepMinutes,
    required this.totalMinutes,
  });

  @override
  State<IngredientFilterPage> createState() => _IngredientFilterPageState();
}

class _IngredientFilterPageState extends State<IngredientFilterPage> {
  Map<String, List<String>> categorizedIngredients = {};
  final Set<String> includeIngredients = {};
  final Set<String> excludeIngredients = {};
  bool _isLoading = false;
  bool _isIngredientsLoaded = false;

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
      _isIngredientsLoaded = true;
    });
  }

  void _showIngredientOptions(String ingredient) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("$ingredient"),
        content: const Text("How would you like to use this ingredient?"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                includeIngredients.add(ingredient);
                excludeIngredients.remove(ingredient);
              });
              Navigator.of(context).pop();
            },
            child: const Text(
              "I want this",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                excludeIngredients.add(ingredient);
                includeIngredients.remove(ingredient);
              });
              Navigator.of(context).pop();
            },
            child: const Text(
              "I don't want this",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void showIngredientsPopup(String category) {
    final allIngredients = categorizedIngredients[category] ?? [];
    List<String> filteredIngredients = List.from(allIngredients)..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
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
                      child: ListView.builder(
                        itemCount: filteredIngredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = filteredIngredients[index];
                          return ListTile(
                            title: Text(ingredient),
                            onTap: () => _showIngredientOptions(ingredient),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close", style: TextStyle(color: Colors.black54)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _startSearch() async {
    setState(() => _isLoading = true);

    final cubit = context.read<RecipeCubit>();
    await cubit.fetchRecipesByTimesWithIngredients(
      maxCookMinutes: widget.cookMinutes,
      maxPrepMinutes: widget.prepMinutes,
      maxTotalMinutes: widget.totalMinutes,
      includeIngredients: includeIngredients.toList(),
      excludeIngredients: excludeIngredients.toList(),
    );

    final state = cubit.state;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeResultsPage(
            recipes: state.recipes,
            selectedIngredients: [],
            sourcePage: "time_limits",
            includeIngredients: includeIngredients.toList(),
            excludeIngredients: excludeIngredients.toList(),
          ),
        ),
      );
  }

  Widget _buildCategoryButton(String category) {
    final iconAsset = categoryIcons[category] ?? "salad.png";
    return GestureDetector(
      onTap: () => showIngredientsPopup(category),
      child: Container(
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
      ),
    );
  }

  Widget _buildSelectedChips() {
    return Wrap(
      spacing: 6.0,
      children: [
        ...includeIngredients.map((ingredient) => Chip(
          label: Text(ingredient),
          backgroundColor: Colors.green.shade300,
          onDeleted: () => setState(() => includeIngredients.remove(ingredient)),
        )),
        ...excludeIngredients.map((ingredient) => Chip(
          label: Text(ingredient),
          backgroundColor: Colors.red.shade300,
          onDeleted: () => setState(() => excludeIngredients.remove(ingredient)),
        )),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: _buildSelectedChips(),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                return _buildCategoryButton(category);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: _startSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBF7E04),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Search Recipes", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.black87,fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Is there an ingredient you would like to '),
                TextSpan(
                  text: 'add',
                  style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' or '),
                TextSpan(
                  text: 'remove',
                  style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '?'),
              ],
            ),
          ),
        ),
      ),

      body: !_isIngredientsLoaded
          ? const Center(child: CircularProgressIndicator())
          : (_isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent()),
    );
  }
}
