import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaGunSayfaCubit extends Cubit<int> {
  VeriAlmaGunSayfaCubit() : super(3);

  void setGunlukYemekSayisi(int yemekSayisi) {
    emit(yemekSayisi);
  }
}
