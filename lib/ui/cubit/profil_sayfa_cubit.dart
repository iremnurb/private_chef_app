import 'package:flutter_bloc/flutter_bloc.dart';
class ProfilSayfaCubit extends Cubit<int> {
  ProfilSayfaCubit() : super(0);

  void navigateTo(int index) {
    emit(index);
  }
}