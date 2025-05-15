import 'package:flutter_bloc/flutter_bloc.dart';
import "package:diyet/data/entity/diyet_list_model.dart";
import '../../../data/repo/repository.dart';

enum DiyetListemSayfaStatus { initial, loading, success, failure }

class DiyetListemSayfaCubit extends Cubit<DiyetListemSayfaState> {
  final DietRepository repository;

  DiyetListemSayfaCubit(this.repository) : super(DiyetListemSayfaState.initial());

  Future<void> fetchDietList(int userId) async {
    try {
      emit(DiyetListemSayfaState.loading());
      final dietList = await repository.fetchDietList(userId);
      emit(DiyetListemSayfaState.success(dietList));
    } catch (e) {
      emit(DiyetListemSayfaState.failure(e.toString()));
    }
  }
}

class DiyetListemSayfaState {
  final DiyetListemSayfaStatus status;
  final List<DietListDay> dietList;
  final String? errorMessage;

  const DiyetListemSayfaState._({
    required this.status,
    this.dietList = const [],
    this.errorMessage,
  });

  factory DiyetListemSayfaState.initial() {
    return const DiyetListemSayfaState._(status: DiyetListemSayfaStatus.initial);
  }

  factory DiyetListemSayfaState.loading() {
    return const DiyetListemSayfaState._(status: DiyetListemSayfaStatus.loading);
  }

  factory DiyetListemSayfaState.success(List<DietListDay> dietList) {
    return DiyetListemSayfaState._(status: DiyetListemSayfaStatus.success, dietList: dietList);
  }

  factory DiyetListemSayfaState.failure(String errorMessage) {
    return DiyetListemSayfaState._(status: DiyetListemSayfaStatus.failure, errorMessage: errorMessage);
  }
}
