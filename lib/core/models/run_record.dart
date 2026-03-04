import 'dart:convert';

class RunRecord {
  final String id;
  final String date; // yyyy-MM-dd
  final double distance; // km
  final int duration; // seconds
  final double calories;
  final List<LatLngPoint> routeData;
  final double avgPace; // min/km

  const RunRecord({
    required this.id,
    required this.date,
    required this.distance,
    required this.duration,
    required this.calories,
    this.routeData = const [],
    this.avgPace = 0.0,
  });

  RunRecord copyWith({
    String? id,
    String? date,
    double? distance,
    int? duration,
    double? calories,
    List<LatLngPoint>? routeData,
    double? avgPace,
  }) {
    return RunRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      routeData: routeData ?? this.routeData,
      avgPace: avgPace ?? this.avgPace,
    );
  }

  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    }
    return '${minutes}m ${seconds}s';
  }

  String get formattedPace {
    if (avgPace <= 0) return '--:--';
    final mins = avgPace.toInt();
    final secs = ((avgPace - mins) * 60).toInt();
    return "$mins'${secs.toString().padLeft(2, '0')}\"";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'distance': distance,
      'duration': duration,
      'calories': calories,
      'route_data': jsonEncode(routeData.map((e) => e.toMap()).toList()),
      'avg_pace': avgPace,
    };
  }

  factory RunRecord.fromMap(Map<String, dynamic> map) {
    List<LatLngPoint> route = [];
    if (map['route_data'] != null && (map['route_data'] as String).isNotEmpty) {
      final decoded = jsonDecode(map['route_data'] as String) as List;
      route = decoded.map((e) => LatLngPoint.fromMap(e as Map<String, dynamic>)).toList();
    }
    return RunRecord(
      id: map['id'] as String,
      date: map['date'] as String,
      distance: (map['distance'] as num).toDouble(),
      duration: map['duration'] as int,
      calories: (map['calories'] as num).toDouble(),
      routeData: route,
      avgPace: (map['avg_pace'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LatLngPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const LatLngPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': latitude,
      'lng': longitude,
      'ts': timestamp.millisecondsSinceEpoch,
    };
  }

  factory LatLngPoint.fromMap(Map<String, dynamic> map) {
    return LatLngPoint(
      latitude: (map['lat'] as num).toDouble(),
      longitude: (map['lng'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['ts'] as int),
    );
  }
}
