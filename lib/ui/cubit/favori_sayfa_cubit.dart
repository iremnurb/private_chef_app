import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/favorite_model.dart';
import '../../data/repo/repository.dart';

class FavoriSayfaCubit extends Cubit<FavoriteCubitState> {
  final FavoriteRepository favoriteRepository;

  FavoriSayfaCubit(this.favoriteRepository) : super(FavoriteInitial());

  Future<void> loadFavorites(int userId) async {
    emit(FavoriteLoading());
    try {
      final favorites = await favoriteRepository.fetchFavorites(userId);
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }

  Future<void> addToFavorites(int userId, int recipeId) async {
    try {
      await favoriteRepository.addFavorite(userId, recipeId);
      await loadFavorites(userId); // Refresh after addition
    } catch (e) {
      emit(FavoriteError('Failed to add to favorites: $e'));
    }
  }

  Future<void> removeFromFavorites(int userId, int recipeId) async {
    try {
      await favoriteRepository.removeFavorite(userId, recipeId);
      await loadFavorites(userId); // Refresh after removal
    } catch (e) {
      emit(FavoriteError('Failed to remove from favorites: $e'));
    }
  }
  Future<List<FavoriteModel>> getFavorites(int userId) async {
    try {
      final favorites = await favoriteRepository.fetchFavorites(userId);
      return favorites;
    } catch (_) {
      return [];
    }
  }

}

abstract class FavoriteCubitState {}

class FavoriteInitial extends FavoriteCubitState {}

class FavoriteLoading extends FavoriteCubitState {}

class FavoriteLoaded extends FavoriteCubitState {
  final List<FavoriteModel> favorites;

  FavoriteLoaded(this.favorites);
}

class FavoriteError extends FavoriteCubitState {
  final String message;

  FavoriteError(this.message);
}
