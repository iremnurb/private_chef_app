import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/user_model.dart';
import '../../data/repo/repository.dart';

class ProfileCubit extends Cubit<UserModel?> {
  final UserRepository repository;

  ProfileCubit(this.repository) : super(null);

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      final user = await repository.updateUser(updatedUser);
      if (user != null) {
        emit(user);
      } else {
        emit(null);
      }
    } catch (e) {
      emit(null);
    }
  }
}
