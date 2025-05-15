class DietListDay {
  final int day;
  final int dailyCalories;
  final Map<String, dynamic>? meals;

  DietListDay({
    required this.day,
    required this.dailyCalories,
    this.meals,
  });

  factory DietListDay.fromJson(Map<String, dynamic> json) {
    return DietListDay(
      day: json['day'],
      dailyCalories: json['dailyCalories'],
      meals: json['meals'],
    );
  }
}
