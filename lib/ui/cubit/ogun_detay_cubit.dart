import 'package:flutter_bloc/flutter_bloc.dart';
import "package:diyet/data/entity/meal_detail_model.dart";
import '../../data/repo/repository.dart';

enum OgunDetayStatus { initial, loading, success, failure }

class OgunDetayState {
  final OgunDetayStatus status;
  final MealDetail? meal;
  final String? errorMessage;

  const OgunDetayState({
    required this.status,
    this.meal,
    this.errorMessage,
  });

  factory OgunDetayState.initial() => const OgunDetayState(status: OgunDetayStatus.initial);
}

class OgunDetayCubit extends Cubit<OgunDetayState> {
  final DietRepository repository;
  OgunDetayCubit(this.repository) : super(OgunDetayState.initial());

  Future<void> fetchMeal(int mealId) async {
    try {
      emit(OgunDetayState(status: OgunDetayStatus.loading));
      final meal = await repository.fetchMealDetail(mealId);
      emit(OgunDetayState(status: OgunDetayStatus.success, meal: meal));
    } catch (e) {
      emit(OgunDetayState(status: OgunDetayStatus.failure, errorMessage: e.toString()));
    }
  }
}