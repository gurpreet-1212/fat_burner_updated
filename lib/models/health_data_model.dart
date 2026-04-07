/// Model for health tracking data (steps, calories, weight, etc.).
/// Extend with additional fields for your tracking needs.
class HealthDataModel {
  final String id;
  final String userId;
  final DateTime date;
  final int? steps;
  final double? weight;
  final int? caloriesBurned;
  final int? caloriesConsumed;

  const HealthDataModel({
    required this.id,
    required this.userId,
    required this.date,
    this.steps,
    this.weight,
    this.caloriesBurned,
    this.caloriesConsumed,
  });

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      steps: json['steps'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      caloriesBurned: json['caloriesBurned'] as int?,
      caloriesConsumed: json['caloriesConsumed'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'steps': steps,
      'weight': weight,
      'caloriesBurned': caloriesBurned,
      'caloriesConsumed': caloriesConsumed,
    };
  }

  HealthDataModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? steps,
    double? weight,
    int? caloriesBurned,
    int? caloriesConsumed,
  }) {
    return HealthDataModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      weight: weight ?? this.weight,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
    );
  }
}
