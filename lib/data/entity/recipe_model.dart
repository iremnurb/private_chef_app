class RecipeModel {
  final int id;
  final String name;
  final String cookTime;
  final String prepTime;
  final String totalTime;
  final String recipeIngredientParts;
  final double calories;
  final double fatContent;
  final double saturatedFatContent;
  final double cholesterolContent;
  final double sodiumContent;
  final double carbohydrateContent;
  final double fiberContent;
  final double sugarContent;
  final double proteinContent;
  final String recipeInstructions;
  final String mealType;
  final String recipeIngredientsQuantities;
  final String? image;
  final List<String>? missingIngredients; // 💡 yeni alan

  RecipeModel({
    required this.id,
    required this.name,
    required this.cookTime,
    required this.prepTime,
    required this.totalTime,
    required this.recipeIngredientParts,
    required this.calories,
    required this.fatContent,
    required this.saturatedFatContent,
    required this.cholesterolContent,
    required this.sodiumContent,
    required this.carbohydrateContent,
    required this.fiberContent,
    required this.sugarContent,
    required this.proteinContent,
    required this.recipeInstructions,
    required this.mealType,
    required this.recipeIngredientsQuantities,
    this.image,
    this.missingIngredients, // 💡 yeni alan
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      name: json['Name'] ?? '',
      cookTime: json['CookTime'] ?? '',
      prepTime: json['PrepTime'] ?? '',
      totalTime: json['TotalTime'] ?? '',
      recipeIngredientParts: json['RecipeIngredientParts'] ?? '',
      calories: (json['Calories'] ?? 0).toDouble(),
      fatContent: (json['FatContent'] ?? 0).toDouble(),
      saturatedFatContent: (json['SaturatedFatContent'] ?? 0).toDouble(),
      cholesterolContent: (json['CholesterolContent'] ?? 0).toDouble(),
      sodiumContent: (json['SodiumContent'] ?? 0).toDouble(),
      carbohydrateContent: (json['CarbohydrateContent'] ?? 0).toDouble(),
      fiberContent: (json['FiberContent'] ?? 0).toDouble(),
      sugarContent: (json['SugarContent'] ?? 0).toDouble(),
      proteinContent: (json['ProteinContent'] ?? 0).toDouble(),
      recipeInstructions: json['RecipeInstructions'] ?? '',
      mealType: json['MealType'] ?? '',
      recipeIngredientsQuantities: json['RecipeIngredientsQuantities'] ?? '',
      image: json['Image'],
      missingIngredients: json['missingIngredients'] != null
          ? List<String>.from(json['missingIngredients'])
          : null,
    );
  }

}
