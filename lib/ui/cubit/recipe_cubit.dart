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
//************************TIME LIMIT MODE + INGREDIENT FILTERS****************************
  Future<void> fetchRecipesByTimesWithIngredients({
    required int maxCookMinutes,
    required int maxPrepMinutes,
    required int maxTotalMinutes,
    required List<String> includeIngredients,
    required List<String> excludeIngredients,
  }) async {
    emit(RecipeState(recipes: [], isLoading: true));
    try {
      final recipes = await repository.fetchRecipesByTimes(
        cookTime: maxCookMinutes,
        prepTime: maxPrepMinutes,
        totalTime: maxTotalMinutes,
        includeIngredients: includeIngredients,
        excludeIngredients: excludeIngredients,
      );
      emit(RecipeState(recipes: recipes, isLoading: false));
    } catch (e) {
      emit(RecipeState(recipes: [], isLoading: false, error: e.toString()));
    }
  }

}