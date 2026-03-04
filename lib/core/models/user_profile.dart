class UserProfile {
  final int? id;
  final String name;
  final int age;
  final double height; // cm
  final double weight; // kg
  final double targetWeight; // kg
  final String gender; // 'male' or 'female'
  final int stepGoal;
  final int dailyCalorieTarget;

  const UserProfile({
    this.id,
    this.name = 'ALEX JOHNSON',
    this.age = 26,
    this.height = 170.0,
    this.weight = 70.0,
    this.targetWeight = 65.0,
    this.gender = 'male',
    this.stepGoal = 10000,
    this.dailyCalorieTarget = 2000,
  });

  UserProfile copyWith({
    int? id,
    String? name,
    int? age,
    double? height,
    double? weight,
    double? targetWeight,
    String? gender,
    int? stepGoal,
    int? dailyCalorieTarget,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      gender: gender ?? this.gender,
      stepGoal: stepGoal ?? this.stepGoal,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'target_weight': targetWeight,
      'gender': gender,
      'step_goal': stepGoal,
      'daily_calorie_target': dailyCalorieTarget,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      name: map['name'] as String? ?? 'ALEX JOHNSON',
      age: map['age'] as int? ?? 26,
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      targetWeight: (map['target_weight'] as num).toDouble(),
      gender: map['gender'] as String,
      stepGoal: map['step_goal'] as int,
      dailyCalorieTarget: map['daily_calorie_target'] as int,
    );
  }
}
