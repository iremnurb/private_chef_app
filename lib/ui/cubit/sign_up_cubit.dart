import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/user_model.dart';
import '../../data/repo/repository.dart';

class SignUpCubit extends Cubit<UserModel?> {
  final UserRepository repository;
  UserModel _user = UserModel(
    username: '',
    email: '',
    password: '',
    gender: '',
    height: 0,
    age: 0,
    weight: 0,
  );

  SignUpCubit(this.repository) : super(null);

  void setUsername(String username) {
    _user = _user.copyWith(username: username);
  }

  void setEmail(String email) {
    _user = _user.copyWith(email: email);
  }

  void setPassword(String password) {
    _user = _user.copyWith(password: password);
  }

  void setGender(String gender) {
    _user = _user.copyWith(gender: gender);
  }

  void setHeight(int height) {
    _user = _user.copyWith(height: height);
  }

  void setAge(int age) {
    _user = _user.copyWith(age: age);
  }

  void setWeight(int weight) {
    _user = _user.copyWith(weight: weight);
  }

  Future<void> signUp() async {
    try {
      final createdUser = await repository.signUp(_user);
      if (createdUser != null) {
        emit(createdUser as UserModel?);  // Kullanıcı bilgisi emit ediliyor
      } else {
        emit(null);  // Başarısız kayıt
      }
    } catch (e) {
      emit(null);  // Hata durumunda null
    }
  }
}
