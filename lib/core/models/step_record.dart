class StepRecord {
  final String date; // yyyy-MM-dd
  final int stepCount;

  const StepRecord({
    required this.date,
    required this.stepCount,
  });

  StepRecord copyWith({
    String? date,
    int? stepCount,
  }) {
    return StepRecord(
      date: date ?? this.date,
      stepCount: stepCount ?? this.stepCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'step_count': stepCount,
    };
  }

  factory StepRecord.fromMap(Map<String, dynamic> map) {
    return StepRecord(
      date: map['date'] as String,
      stepCount: map['step_count'] as int,
    );
  }

  /// Calculate calories burned from steps
  double caloriesBurned(double userWeight) {
    return stepCount * 0.04 * userWeight / 70.0;
  }
}
