import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../models/run_record.dart';
import 'database_service.dart';

enum RunState { idle, running, paused, stopped }

class RunTrackingService {
  final _uuid = const Uuid();

  RunState _state = RunState.idle;
  final List<LatLngPoint> _route = [];
  double _distance = 0.0; // meters
  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;
  int _elapsedSeconds = 0;

  final _stateController = StreamController<RunState>.broadcast();
  final _distanceController = StreamController<double>.broadcast();
  final _durationController = StreamController<int>.broadcast();
  final _paceController = StreamController<double>.broadcast();
  final _routeController = StreamController<List<LatLngPoint>>.broadcast();

  Stream<RunState> get stateStream => _stateController.stream;
  Stream<double> get distanceStream => _distanceController.stream;
  Stream<int> get durationStream => _durationController.stream;
  Stream<double> get paceStream => _paceController.stream;
  Stream<List<LatLngPoint>> get routeStream => _routeController.stream;

  RunState get state => _state;
  double get distance => _distance / 1000; // km
  int get durationSeconds => _elapsedSeconds;
  List<LatLngPoint> get route => List.unmodifiable(_route);

  double get currentPace {
    final distKm = _distance / 1000;
    if (distKm <= 0 || _elapsedSeconds <= 0) return 0;
    return (_elapsedSeconds / 60) / distKm; // min/km
  }

  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<void> startRun() async {
    if (_state == RunState.running) return;

    final hasPermission = await _checkPermission();
    if (!hasPermission) return;

    _state = RunState.running;
    _route.clear();
    _distance = 0;
    _elapsedSeconds = 0;

    _stateController.add(_state);
    _distanceController.add(0);
    _durationController.add(0);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state == RunState.running) {
        _elapsedSeconds++;
        _durationController.add(_elapsedSeconds);
        _paceController.add(currentPace);
      }
    });

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) {
      final point = LatLngPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );

      if (_route.isNotEmpty) {
        final lastPoint = _route.last;
        final dist = Geolocator.distanceBetween(
          lastPoint.latitude,
          lastPoint.longitude,
          point.latitude,
          point.longitude,
        );
        _distance += dist;
        _distanceController.add(distance);
      }

      _route.add(point);
      _routeController.add(List.from(_route));
    });
  }

  void pauseRun() {
    if (_state != RunState.running) return;
    _state = RunState.paused;
    _stateController.add(_state);
  }

  void resumeRun() {
    if (_state != RunState.paused) return;
    _state = RunState.running;
    _stateController.add(_state);
  }

  Future<RunRecord?> stopRun(double userWeight) async {
    if (_state == RunState.idle) return null;

    _state = RunState.stopped;
    _stateController.add(_state);
    _timer?.cancel();
    _positionSubscription?.cancel();

    if (_distance < 10 && _elapsedSeconds < 10) {
      _state = RunState.idle;
      _stateController.add(_state);
      return null;
    }

    final durationHours = _elapsedSeconds / 3600.0;
    final calories = AppConstants.runningMET * userWeight * durationHours;

    final record = RunRecord(
      id: _uuid.v4(),
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      distance: distance,
      duration: _elapsedSeconds,
      calories: calories,
      routeData: List.from(_route),
      avgPace: currentPace,
    );

    await DatabaseService.insertRun(record);

    _state = RunState.idle;
    _stateController.add(_state);

    return record;
  }

  void dispose() {
    _timer?.cancel();
    _positionSubscription?.cancel();
    _stateController.close();
    _distanceController.close();
    _durationController.close();
    _paceController.close();
    _routeController.close();
  }
}
