import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnaSayfaCubit extends Cubit<int> {
  AnaSayfaCubit() : super(0);

  void navigateTo(int index) {
    emit(index);
  }
}
