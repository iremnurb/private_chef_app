import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/entity/recipe_model.dart';
import '../../cubit/ingredient_bag_cubit.dart';
import '../diyet/ogun_detay_sayfa.dart';

class RecipeListByCategoryPage extends StatefulWidget {
  final String title;
  final List<RecipeModel> recipes;
  final String sourcePage;
  final List<String>? includeIngredients;
  final List<String>? excludeIngredients;

  const RecipeListByCategoryPage({
    super.key,
    required this.title,
    required this.recipes,
    required this.sourcePage,
    this.includeIngredients,
    this.excludeIngredients,
  });

  @override
  State<RecipeListByCategoryPage> createState() => RecipeListByCategoryPageState();
}

class RecipeListByCategoryPageState extends State<RecipeListByCategoryPage> {
  late List<RecipeModel> filtered;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter;

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
      _applyFilter();
    });
  }

  // Süreyi dakikaya çeviren yardımcı fonksiyon
  int _parseTimeToMinutes(String time) {
    time = time.trim().toUpperCase();
    int totalMinutes = 0;

    final hourMatch = RegExp(r'(\d+)H').firstMatch(time);
    final minuteMatch = RegExp(r'(\d+)M').firstMatch(time);

    if (hourMatch != null) {
      final hours = int.parse(hourMatch.group(1)!);
      totalMinutes += hours * 60;
    }

    if (minuteMatch != null) {
      final minutes = int.parse(minuteMatch.group(1)!);
      totalMinutes += minutes;
    }

    return totalMinutes;
  }

  // Eşleşen malzeme sayısını hesaplayan yardımcı fonksiyon
  int _countMatchedIngredients(RecipeModel recipe) {
    final totalIngredients = recipe.recipeIngredientParts.split(',').map((e) => e.trim()).length;
    final missingCount = recipe.missingIngredients?.length ?? 0;
    return totalIngredients - missingCount;
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == null) return;

      switch (_selectedFilter) {
        case 'Most Included Ingredients':
          if (widget.sourcePage == "macros_selection") {
            filtered.sort((a, b) {
              final aMatched = _countMatchedIngredients(a);
              final bMatched = _countMatchedIngredients(b);
              return bMatched.compareTo(aMatched); // Azalan sırayla
            });
          }
          break;
        case 'Cook Time (Ascending)':
          filtered.sort((a, b) => _parseTimeToMinutes(a.cookTime).compareTo(_parseTimeToMinutes(b.cookTime)));
          break;
        case 'Cook Time (Descending)':
          filtered.sort((a, b) => _parseTimeToMinutes(b.cookTime).compareTo(_parseTimeToMinutes(a.cookTime)));
          break;
        case 'Prep Time (Ascending)':
          filtered.sort((a, b) => _parseTimeToMinutes(a.prepTime).compareTo(_parseTimeToMinutes(b.prepTime)));
          break;
        case 'Prep Time (Descending)':
          filtered.sort((a, b) => _parseTimeToMinutes(b.prepTime).compareTo(_parseTimeToMinutes(a.prepTime)));
          break;
        case 'Total Time (Ascending)':
          filtered.sort((a, b) => _parseTimeToMinutes(a.totalTime).compareTo(_parseTimeToMinutes(b.totalTime)));
          break;
        case 'Total Time (Descending)':
          filtered.sort((a, b) => _parseTimeToMinutes(b.totalTime).compareTo(_parseTimeToMinutes(a.totalTime)));
          break;
        case 'Calories (Ascending)':
          filtered.sort((a, b) => a.calories.compareTo(b.calories));
          break;
        case 'Calories (Descending)':
          filtered.sort((a, b) => b.calories.compareTo(a.calories));
          break;
      }
    });
  }

  void _clearFilter() {
    setState(() {
      _selectedFilter = null;
      _filter(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.title}s"),
        titleTextStyle: GoogleFonts.poppins(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                hintStyle: TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search),

                suffixIcon: DropdownButton<String>(
                  //style: TextStyle(fontSize: 15),
                  value: _selectedFilter,
                  icon: Container(
                    margin: EdgeInsets.only(right: 5),
                    child: const Icon(Icons.filter_list, color: Color(0xFFBF7E04),),
                  ),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue;
                      _filter(_searchController.text);
                    });
                  },
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      enabled: false,
                      child: Text('Filter', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    if (widget.sourcePage == "macros_selection")
                      const DropdownMenuItem(
                        value: 'Most Included Ingredients',
                        child: Text('Most Included', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                      ),
                    const DropdownMenuItem(
                      value: 'Cook Time (Ascending)',
                      child: Text('Cook ↑', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Cook Time (Descending)',
                      child: Text('Cook ↓', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Prep Time (Ascending)',
                      child: Text('Prep ↑', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Prep Time (Descending)',
                      child: Text('Prep ↓', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Total Time (Ascending)',
                      child: Text('Total ↑', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Total Time (Descending)',
                      child: Text('Total ↓', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Calories (Ascending)',
                      child: Text('Cal ↑', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                    const DropdownMenuItem(
                      value: 'Calories (Descending)',
                      child: Text('Cal ↓', style: TextStyle(fontSize: 14, color: Color(0xFFBF7E04))),
                    ),
                  ],
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
                        Text("Prep: ${recipe.prepTime} | Cook: ${recipe.cookTime} | Total: ${recipe.totalTime}"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showIngredientsModal(recipe),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFBF7E04), width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  "Show Ingredients",
                                  style: GoogleFonts.poppins(color: const Color(0xFFBF7E04), fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OgunDetaySayfa(mealId: recipe.id, themeColor: const Color(0xFFBF7E04)),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFBF7E04), width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  "Show Details",
                                  style: GoogleFonts.poppins(color: const Color(0xFFBF7E04), fontSize: 13),
                                ),
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

  void _showIngredientsModal(RecipeModel recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    final allIngredients = recipe.recipeIngredientParts.split(',').map((e) => e.trim()).toList();
    final missing = recipe.missingIngredients ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (widget.sourcePage == "macros_selection") ...[
                Text("You already have:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ...allIngredients.where((i) => !missing.map((e) => e.toLowerCase()).contains(i.toLowerCase())).map(
                      (i) => ListTile(
                    title: Text(i),
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 16),
                Text("You don't have:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ...allIngredients.where((i) => missing.map((e) => e.toLowerCase()).contains(i.toLowerCase())).map(
                      (i) => ListTile(
                    title: Text(i),
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart_outlined, color: Colors.black54,size: 20,),
                      onPressed: () {
                        if (userId != null) {
                          context.read<IngredientBagCubit>().addIngredient(userId, i);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$i added to your bag')),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ] else ...[
                Text("Ingredients:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ...allIngredients.map(
                      (i) => ListTile(
                    title: Text(i),
                    leading: const Icon(Icons.info, color: Color(0xFFF2B33D)),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBF7E04),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Close", style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}