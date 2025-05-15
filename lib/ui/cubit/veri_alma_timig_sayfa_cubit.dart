import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaTimingSayfaCubit extends Cubit<List<TimeOfDay?>> {
  VeriAlmaTimingSayfaCubit() : super(List.filled(4, null));

  void updateTime(int index, TimeOfDay time) {
    final newList = List<TimeOfDay?>.from(state);
    newList[index] = time;
    emit(newList);
  }
}
