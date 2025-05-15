import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaKiloSayfaCubit extends Cubit<int> {
  VeriAlmaKiloSayfaCubit({int hedefKilo = 70}) : super(hedefKilo);

  void setKilo(int yeni) => emit(yeni);
}
