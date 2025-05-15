import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/login_cubit.dart';
import '../../data/entity/recipe_model.dart';
import '../cubit/favori_sayfa_cubit.dart';
import 'diyet/ogun_detay_sayfa.dart';


class FavoriSayfa extends StatefulWidget {
  const FavoriSayfa({Key? key}) : super(key: key);

  @override
  State<FavoriSayfa> createState() => _FavoriSayfaState();
}

class _FavoriSayfaState extends State<FavoriSayfa> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userId = context.read<LoginCubit>().state?.id ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Recipes",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
                      final name = f.recipe.name.toLowerCase();
                      return name.contains(searchQuery);
                    }).toList();

                    if (filteredFavorites.isEmpty) {
                      return const Center(child: Text("No matching recipes found."));
                    }

                    return ListView.builder(
                      itemCount: filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredFavorites[index].recipe;

                        return Card(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.bookmark, color: Colors.white),
                            ),
                            title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                  builder: (_) => OgunDetaySayfa(mealId: recipe.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    // İlk yükleme için tetikle
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
}
