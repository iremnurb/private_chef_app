class MealDetail {
  final int id;
  final String name;
  final String? imageUrl;
  final double calories;
  final String totalTime;
  final double carbs;
  final double proteins;
  final double fats;
  final List<String> ingredients; // Güncellendi!
  final String instructions;

  MealDetail({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.calories,
    required this.totalTime,
    required this.carbs,
    required this.proteins,
    required this.fats,
    required this.ingredients,
    required this.instructions,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredientString = json['ingredients'] as String? ?? '';
    final ingredientList = ingredientString
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return MealDetail(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      calories: json['calories'].toDouble(),
      totalTime: json['totalTime'],
      carbs: json['carbs'].toDouble(),
      proteins: json['proteins'].toDouble(),
      fats: json['fats'].toDouble(),
      ingredients: ingredientList,
      instructions: json['instructions'],
    );
  }
}
