import 'package:diyet/data/entity/recipe_model.dart';

class FavoriteModel {
  final int id;
  final int userId;
  final int recipeId;
  final RecipeModel recipe; // favori tarifin tüm detayları

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.recipe,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['userId'],
      recipeId: json['recipeId'],
      recipe: RecipeModel.fromJson(json['Recipe']),
    );
  }
}
