import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaTimigSayfaCubit extends Cubit<int> {
 VeriAlmaTimigSayfaCubit() : super(0);

  void navigateTo(int index) {
    emit(index);
  }
}