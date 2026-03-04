enum ActivityType {
  walking,
  running,
  cycling,
  trekking;

  String get displayName {
    switch (this) {
      case ActivityType.walking: return 'Walking';
      case ActivityType.running: return 'Running';
      case ActivityType.cycling: return 'Cycling';
      case ActivityType.trekking: return 'Trekking';
    }
  }

  static ActivityType fromString(String value) {
    return ActivityType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ActivityType.walking,
    );
  }
}

class ActivityRecord {
  final String id;
  final ActivityType type;
  final String date; // yyyy-MM-dd
  final DateTime startTime;
  final int duration; // seconds
  final double calories;
  final double distance; // km

  const ActivityRecord({
    required this.id,
    required this.type,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'date': date,
      'start_time': startTime.toIso8601String(),
      'duration': duration,
      'calories': calories,
      'distance': distance,
    };
  }

  factory ActivityRecord.fromMap(Map<String, dynamic> map) {
    return ActivityRecord(
      id: map['id'] as String,
      type: ActivityType.fromString(map['type'] as String),
      date: map['date'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      duration: map['duration'] as int,
      calories: (map['calories'] as num).toDouble(),
      distance: (map['distance'] as num).toDouble(),
    );
  }

  String get formattedTime {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }
}
