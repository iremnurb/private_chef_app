import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/entity/recipe_model.dart';
import '../../../data/repo/repository.dart';

class RecipeState {
  final List<RecipeModel> recipes;
  final bool isLoading;
  final String? error;

  RecipeState({
    required this.recipes,
    required this.isLoading,
    this.error,
  });

  factory RecipeState.initial() => RecipeState(recipes: [], isLoading: false);
}

class RecipeCubit extends Cubit<RecipeState> {
  final UserRepository repository;

  RecipeCubit(this.repository) : super(RecipeState.initial());

  //************************WHATS IN MY FRIDGE MODE****************************
  Future<void> fetchRecipesWithAdvancedFilter({
    required List<String> ingredients,
    required List<String> mealType,
    required int maxCalories,
    double? fat,
    double? protein,
    double? carbs,
    double? sugar,
  }) async {
    emit(RecipeState(recipes: [], isLoading: true));
    try {
      final recipes = await repository.fetchRecipesWithAdvancedFilter(
        ingredients: ingredients,
        mealType: mealType,
        maxCalories: maxCalories,
        fat: fat,
        protein: protein,
        carbs: carbs,
        sugar: sugar,
      );
      emit(RecipeState(recipes: recipes, isLoading: false));
    } catch (e) {
      emit(RecipeState(recipes: [], isLoading: false, error: e.toString()));
    }
  }



  //************************TIME LIMIT MODE****************************
  Future<void> fetchRecipesByTimeLimit(int totalMinutes) async {
    emit(RecipeState(recipes: [], isLoading: true));
    try {
      final recipes = await repository.fetchRecipesByTimeLimit(totalMinutes);
      emit(RecipeState(recipes: recipes, isLoading: false));
    } catch (e) {
      emit(RecipeState(recipes: [], isLoading: false, error: e.toString()));
    }
  }
}