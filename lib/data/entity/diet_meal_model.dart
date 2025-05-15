class DietMealModel {
  final int? id;
  final int dietId;
  final int recipeId;
  final DateTime date;
  final String mealTime; // format: HH:mm:ss

  DietMealModel({
    this.id,
    required this.dietId,
    required this.recipeId,
    required this.date,
    required this.mealTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'diet_id': dietId,
      'recipe_id': recipeId,
      'date': date.toIso8601String(),
      'meal_time': mealTime,
    };
  }

  factory DietMealModel.fromJson(Map<String, dynamic> json) {
    return DietMealModel(
      id: json['id'],
      dietId: json['diet_id'],
      recipeId: json['recipe_id'],
      date: DateTime.parse(json['date']),
      mealTime: json['meal_time'],
    );
  }
}
