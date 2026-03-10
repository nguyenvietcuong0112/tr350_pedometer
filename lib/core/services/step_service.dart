import 'dart:async';
import 'package:pedometer/pedometer.dart' as ped;
import 'package:intl/intl.dart';
import 'database_service.dart';
import '../models/step_record.dart';

class StepService {
  StreamSubscription<ped.StepCount>? _stepSubscription;
  StreamSubscription<ped.PedestrianStatus>? _statusSubscription;
  int _initialStepCount = 0;
  int _currentSteps = 0;
  String _pedestrianStatus = 'unknown';

  final _stepController = StreamController<int>.broadcast();
  final _statusController = StreamController<String>.broadcast();

  Stream<int> get stepStream => _stepController.stream;
  Stream<String> get statusStream => _statusController.stream;
  int get currentSteps => _currentSteps;
  String get pedestrianStatus => _pedestrianStatus;

  Future<void> startListening() async {
    // Get today's saved steps
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final savedRecord = await DatabaseService.getStepRecord(today);
    _currentSteps = savedRecord?.stepCount ?? 0;

    try {
      _stepSubscription = ped.Pedometer.stepCountStream.listen(
        (event) {
          if (_initialStepCount == 0) {
            _initialStepCount = event.steps;
          }
          final stepsFromSensor = event.steps - _initialStepCount;
          if (stepsFromSensor > 0) {
            _currentSteps = (_currentSteps > stepsFromSensor)
                ? _currentSteps
                : stepsFromSensor;
          }
          _stepController.add(_currentSteps);
          _saveSteps();
        },
        onError: (error) {
          _stepController.addError(error);
        },
      );

      _statusSubscription = ped.Pedometer.pedestrianStatusStream.listen(
        (event) {
          _pedestrianStatus = event.status;
          _statusController.add(_pedestrianStatus);
        },
        onError: (error) {
          _statusController.addError(error);
        },
      );
    } catch (e) {
      print('Pedometer sensors not available: $e');
      _stepController.addError('Sensors not available');
      _statusController.add('unknown');
    }
  }

  Future<void> _saveSteps() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await DatabaseService.upsertStepRecord(
      StepRecord(date: today, stepCount: _currentSteps),
    );
  }

  void addManualSteps(int steps) {
    _currentSteps += steps;
    _stepController.add(_currentSteps);
    _saveSteps();
  }

  void dispose() {
    _stepSubscription?.cancel();
    _statusSubscription?.cancel();
    _stepController.close();
    _statusController.close();
  }
}
