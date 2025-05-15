import 'package:flutter_bloc/flutter_bloc.dart';

class VeriAlmaHareketSayfaCubit extends Cubit<String> {
  VeriAlmaHareketSayfaCubit({String aktivite = 'moderate'}) : super(aktivite);

  void setAktivite(String yeni) => emit(yeni);
}
