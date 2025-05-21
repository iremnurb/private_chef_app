import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/entity/recipe_model.dart';
import '../cubit/favori_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/login_cubit.dart';
import 'diyet/ogun_detay_sayfa.dart';

class FavoriSayfa extends StatefulWidget {
  const FavoriSayfa({Key? key}) : super(key: key);

  @override
  State<FavoriSayfa> createState() => _FavoriSayfaState();
}

class _FavoriSayfaState extends State<FavoriSayfa> {
  String searchQuery = '';
  String mealTypeFilter = 'All';

  final List<String> filterOptions = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack','Dessert'];

  @override
  Widget build(BuildContext context) {
    final userId = context.read<LoginCubit>().state?.id ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "My Foods",
              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = filterOptions[index];
                  final isSelected = mealTypeFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Row(
                        children: [
                          Icon(_getIconForFilter(filter), size: 18, color: isSelected ? Colors.white : Colors.black),
                          const SizedBox(width: 4),
                          Text(filter),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: Color(0xFFD9BBA9),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      onSelected: (_) {
                        setState(() {
                          mealTypeFilter = filter;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<FavoriSayfaCubit, FavoriteCubitState>(
                builder: (context, state) {
                  if (state is FavoriteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FavoriteError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is FavoriteLoaded) {
                    final allFavorites = state.favorites;
                    final filteredFavorites = allFavorites.where((f) {
                      final nameMatch = f.recipe.name.toLowerCase().contains(searchQuery);
                      final mealMatch = mealTypeFilter == 'All' ||
                          f.recipe.mealType?.toLowerCase() == mealTypeFilter.toLowerCase();
                      return nameMatch && mealMatch;
                    }).toList();

                    if (filteredFavorites.isEmpty) {
                      return const Center(child: Text("No matching recipes found."));
                    }

                    return ListView.builder(
                      itemCount: filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredFavorites[index].recipe;
                        final imagePath =
                            'assets/images/${recipe.mealType ?? 'default'}.png';

                        return Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                imagePath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 50);
                                },
                              ),
                            ),
                            title: Text(recipe.name,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (recipe.mealType != null)
                                  Text("Type: ${recipe.mealType!}"),
                                if (recipe.calories != null)
                                  Text("Calories: ${recipe.calories!.toStringAsFixed(0)} kcal"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.red),
                              onPressed: () {
                                context.read<FavoriSayfaCubit>().removeFromFavorites(userId, recipe.id);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OgunDetaySayfa(mealId: recipe.id,  themeColor: Color(0xFFD9BBA9)),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    context.read<FavoriSayfaCubit>().loadFavorites(userId);
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForFilter(String filter) {
    switch (filter) {
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.cookie;
      case 'Dessert':
        return Icons.cruelty_free_rounded;
      default:
        return Icons.all_inclusive;
    }
  }
}
