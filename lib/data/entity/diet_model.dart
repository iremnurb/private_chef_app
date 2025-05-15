class DietModel {
  final int? id;
  final int? userId;
  final DateTime startDate;
  final DateTime endDate;
  final int? targetWeight;
  final int? mealCount;
  final String? status;
  final String? activity;
  final String? breakfastTime;
  final String? lunchTime;
  final String? snackTime;
  final String? dinnerTime;


  DietModel({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.targetWeight,
    required this.mealCount,
    required this.status,
    required this.activity,
    required this.breakfastTime,
    required this.dinnerTime,
    required this.lunchTime,
    required this.snackTime
  });

  factory DietModel.fromJson(Map<String, dynamic> json) {
    return DietModel(
      id: json['id'],
      userId: json['user_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      targetWeight: json['target_weight'],
      mealCount: json['meal_count'],
      status: json['status'],
      activity: json['activity'],
      breakfastTime: json['breakfast_time'],
      lunchTime: json['lunch_time'],
      snackTime: json['snack_time'],
      dinnerTime: json['dinner_time'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'target_weight': targetWeight,
      'meal_count': mealCount,
      'status': status,
      'activity': activity,
      'breakfast_time': breakfastTime,
      'lunch_time': lunchTime,
      'snack_time': snackTime,
      'dinner_time': dinnerTime,

    };
  }
}
