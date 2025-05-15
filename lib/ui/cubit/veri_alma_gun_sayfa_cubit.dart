import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaGunSayfaCubit extends Cubit<int> {
  VeriAlmaGunSayfaCubit() : super(7);

  void setGunSayisi(int sayi) => emit(sayi);
}
