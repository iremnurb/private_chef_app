import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaHareketSayfaCubit extends Cubit<String> {
  VeriAlmaHareketSayfaCubit() : super("Low");

  void setHareketSeviyesi(String hareket) {
    emit(hareket);
  }
}