import 'package:diyet/data/repo/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ForgotPasswordCubit extends Cubit<void> {
  final UserRepository _repository;

  ForgotPasswordCubit(this._repository) : super(null);

  Future<String> resetPassword(String email, String newPassword) async {
    try {
      final result = await _repository.resetPassword(email, newPassword);
      return result;
    } catch (e) {
      return "Reset failed: ${e.toString()}";
    }
  }
}
