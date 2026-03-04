import 'dart:async';
import 'package:geolocator/geolocator.dart' hide ActivityType;
import 'package:pedometer/pedometer.dart';
import 'package:uuid/uuid.dart';
import '../models/activity_record.dart';
import '../models/run_record.dart'; // Reusing LatLngPoint
import '../constants.dart';
import 'database_service.dart';

enum TrackingState { idle, active, paused, stop }

class ActivityTrackingService {
  final ActivityType type;
  final double userWeight;
  
  TrackingState _state = TrackingState.idle;
  int _seconds = 0;
  double _distance = 0.0; // meters
  int _steps = 0;
  int _initialSteps = -1;
  final List<LatLngPoint> _route = [];
  
  Timer? _timer;
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<StepCount>? _pedometerSub;
  
  final _stateController = StreamController<TrackingState>.broadcast();
  final _metricsController = StreamController<TrackingMetrics>.broadcast();
  final _routeController = StreamController<List<LatLngPoint>>.broadcast();

  ActivityTrackingService({required this.type, required this.userWeight});

  Stream<TrackingState> get stateStream => _stateController.stream;
  Stream<TrackingMetrics> get metricsStream => _metricsController.stream;
  Stream<List<LatLngPoint>> get routeStream => _routeController.stream;

  TrackingState get state => _state;
  
  Future<void> start() async {
    if (_state == TrackingState.active) return;
    
    // Check Permissions
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) return;
    
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    _state = TrackingState.active;
    _stateController.add(_state);
    
    // Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state == TrackingState.active) {
        _seconds++;
        _emitMetrics();
      }
    });

    // GPS
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      if (_state != TrackingState.active) return;
      
      final point = LatLngPoint(
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: DateTime.now(),
      );
      
      if (_route.isNotEmpty) {
        _distance += Geolocator.distanceBetween(
          _route.last.latitude,
          _route.last.longitude,
          point.latitude,
          point.longitude,
        );
      }
      
      _route.add(point);
      _routeController.add(List.from(_route));
      _emitMetrics();
    });

    // Pedometer (Only for walking/running/trekking)
    if (type != ActivityType.cycling) {
      _pedometerSub = Pedometer.stepCountStream.listen((event) {
        if (_state != TrackingState.active) return;
        if (_initialSteps == -1) {
          _initialSteps = event.steps;
        }
        _steps = event.steps - _initialSteps;
        _emitMetrics();
      });
    }
  }

  void pause() {
    if (_state != TrackingState.active) return;
    _state = TrackingState.paused;
    _stateController.add(_state);
  }

  void resume() {
    if (_state != TrackingState.paused) return;
    _state = TrackingState.active;
    _stateController.add(_state);
  }

  Future<ActivityRecord?> stop() async {
    _state = TrackingState.stop;
    _stateController.add(_state);
    
    _timer?.cancel();
    _positionSub?.cancel();
    _pedometerSub?.cancel();

    if (_distance < 5 && _seconds < 5) return null;

    final metrics = _calculateMetrics();
    final record = ActivityRecord(
      id: const Uuid().v4(),
      type: type,
      date: DateTime.now().toIso8601String().split('T')[0],
      startTime: DateTime.now().subtract(Duration(seconds: _seconds)),
      duration: _seconds,
      calories: metrics.calories,
      distance: _distance / 1000,
    );

    await DatabaseService.insertActivity(record);
    return record;
  }

  void _emitMetrics() {
    _metricsController.add(_calculateMetrics());
  }

  TrackingMetrics _calculateMetrics() {
    final met = AppConstants.metValues[type.name] ?? 3.5;
    final hours = _seconds / 3600;
    final calories = met * userWeight * hours;
    
    return TrackingMetrics(
      durationSeconds: _seconds,
      distanceMeters: _distance,
      steps: _steps,
      calories: calories,
    );
  }

  void dispose() {
    _timer?.cancel();
    _positionSub?.cancel();
    _pedometerSub?.cancel();
    _stateController.close();
    _metricsController.close();
    _routeController.close();
  }
}

class TrackingMetrics {
  final int durationSeconds;
  final double distanceMeters;
  final int steps;
  final double calories;

  TrackingMetrics({
    required this.durationSeconds,
    required this.distanceMeters,
    required this.steps,
    required this.calories,
  });

  double get distanceKm => distanceMeters / 1000;
  String get formattedTime {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    final s = durationSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
