import 'package:diyet/data/repo/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Ingredient icin ufak bir model olusturduk, sadece isAcquired alanina bakmak icin
class IngredientItem {
  final String name;
  final bool isAcquired;

  IngredientItem({required this.name, required this.isAcquired});

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(
      name: json['ingredient'],
      isAcquired: json['isAcquired'] == true || json['isAcquired'] == 1,
    );
  }
}


class IngredientBagState {
  final List<IngredientItem> ingredients;
  final bool isLoading;
  final String? error;

  IngredientBagState({
    required this.ingredients,
    required this.isLoading,
    this.error,
  });

  factory IngredientBagState.initial() =>
      IngredientBagState(ingredients: [], isLoading: false);
}

class IngredientBagCubit extends Cubit<IngredientBagState> {
  final UserRepository repository;

  IngredientBagCubit(this.repository) : super(IngredientBagState.initial());

  Future<void> fetchBag(int userId) async {
    emit(IngredientBagState(ingredients: [], isLoading: true));
    try {
      final ingredients = await repository.fetchbag(userId);
      emit(IngredientBagState(ingredients: ingredients, isLoading: false));
    } catch (e) {
      emit(IngredientBagState(ingredients: [], isLoading: false, error: e.toString()));
    }
  }


  Future<void> addIngredient(int userId, String ingredient) async {
    try {
      await repository.addToBag(userId, ingredient);
      await fetchBag(userId);
    } catch (e) {
      emit(IngredientBagState(ingredients: state.ingredients, isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteIngredient(int userId, String ingredient) async {
    try {
      await repository.deleteFromBag(userId, ingredient);
      await fetchBag(userId);
    } catch (e) {
      emit(IngredientBagState(ingredients: state.ingredients, isLoading: false, error: e.toString()));
    }
  }

  Future<void> markAsAcquired(int userId, String ingredient) async {
    try {
      await repository.markAsAcquired(userId, ingredient);
      await fetchBag(userId);
    } catch (e) {
      emit(IngredientBagState(ingredients: state.ingredients, isLoading: false, error: e.toString()));
    }
  }
}
