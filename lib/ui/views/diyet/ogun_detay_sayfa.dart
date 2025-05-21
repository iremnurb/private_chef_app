import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubit/ogun_detay_cubit.dart';
import "package:diyet/data/entity/meal_detail_model.dart";
import 'package:diyet/data/repo/repository.dart';
import 'package:diyet/ui/cubit/favori_sayfa_cubit.dart';
import '../../cubit/login_cubit.dart';

class OgunDetaySayfa extends StatefulWidget {
  final int mealId;
  final Color? themeColor;
  const OgunDetaySayfa({Key? key, required this.mealId,this.themeColor,}) : super(key: key);
  @override
  State<OgunDetaySayfa> createState() => _OgunDetaySayfaState();
}

class _OgunDetaySayfaState extends State<OgunDetaySayfa> {

  int selectedIndex = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }
  void _checkIfFavorite() async {
    final userId = context.read<LoginCubit>().state?.id ?? 0;
    final favorites = await context.read<FavoriSayfaCubit>().getFavorites(userId);
    final isFav = favorites.any((fav) => fav.recipe.id == widget.mealId);

    setState(() {
      isFavorite = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.themeColor ??  Color(0xFF7C8C03);
    return BlocProvider(
      create: (_) => OgunDetayCubit(DietRepository())..fetchMeal(widget.mealId),
      child: BlocBuilder<OgunDetayCubit, OgunDetayState>(
        builder: (context, state) {
          if (state.status == OgunDetayStatus.loading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state.status == OgunDetayStatus.failure) {
            return Scaffold(body: Center(child: Text('Error: ${state.errorMessage}')));
          } else if (state.status == OgunDetayStatus.success && state.meal != null) {
            final meal = state.meal!;
            final userId = context.read<LoginCubit>().state?.id ?? 0;

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        meal.imageUrl != null
                            ? Image.network(meal.imageUrl!, width: double.infinity, height: 180, fit: BoxFit.cover)
                            : Container(height: 180, width: double.infinity, color: Colors.grey[300]),
                        Positioned(
                          top: 40,
                          left: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black,
                              ),
                              onPressed: () async {
                                if (isFavorite) {
                                  await context.read<FavoriSayfaCubit>().removeFromFavorites(userId, meal.id);
                                } else {
                                  await context.read<FavoriSayfaCubit>().addToFavorites(userId, meal.id);
                                }
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  meal.name,
                                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Row(children: [
                                const Icon(Icons.timer, size: 18),
                                const SizedBox(width: 4),
                                Text(meal.totalTime),
                              ])
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _macroIcon(Icons.grain, '${meal.carbs}g carbs'),
                              _macroIcon(Icons.set_meal, '${meal.proteins}g proteins'),
                              _macroIcon(Icons.local_fire_department, '${meal.calories} Kcal'),
                              _macroIcon(Icons.local_pizza, '${meal.fats}g fats'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF0F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                _buildSwitchButton(0, "Ingredients"),
                                _buildSwitchButton(1, "Instructions"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          selectedIndex == 0
                              ? Column(
                            children: meal.ingredients
                                .map(
                                  (item) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F8F8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(item,
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .toList(),
                          )
                              : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(meal.instructions),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: widget.themeColor,
                              ),
                              child:  Text(
                                'Got it!',
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildSwitchButton(int index, String text) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? widget.themeColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _macroIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }
}
