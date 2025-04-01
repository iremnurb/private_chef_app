import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/repository.dart';

class LoginCubit extends Cubit<String> {
  final UserRepository repository;

  LoginCubit(this.repository) : super('');

  Future<void> login(String email, String password) async {
    try {
      final response = await repository.login(email, password);
      print("API Response: $response");
      emit(response);
    } catch (e) {
      print("Error during login: $e");
      emit("Error: $e");
    }
  }
}
