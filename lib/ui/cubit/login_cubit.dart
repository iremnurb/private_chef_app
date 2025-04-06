import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/user_model.dart';
import '../../data/repo/repository.dart';

class LoginCubit extends Cubit<UserModel?> {
  final UserRepository repository;

  LoginCubit(this.repository) : super(null);

  Future<void> login(String email, String password) async {
    try {
      final user = await repository.login(email, password);
      if (user != null) {
        emit(user);  // Başarılı giriş
      } else {
        emit(null);  // Başarısız giriş
      }
    } catch (e) {
      emit(null);  // Hata durumunda null
    }
  }
}
