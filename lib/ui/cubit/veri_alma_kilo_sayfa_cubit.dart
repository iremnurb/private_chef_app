import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class VeriAlmaKiloSayfaCubit extends Cubit<double> {
  VeriAlmaKiloSayfaCubit() : super(0.0);

  void setKilo(double kilo) {
    emit(kilo);
  }
}
