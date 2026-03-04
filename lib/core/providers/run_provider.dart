import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/run_tracking_service.dart';
import '../models/run_record.dart';
import '../services/database_service.dart';
import 'profile_provider.dart';

final runTrackingServiceProvider = Provider<RunTrackingService>((ref) {
  final service = RunTrackingService();
  ref.onDispose(() => service.dispose());
  return service;
});

final runStateProvider = StreamProvider<RunState>((ref) {
  final service = ref.watch(runTrackingServiceProvider);
  return service.stateStream;
});

final runDistanceProvider = StreamProvider<double>((ref) {
  final service = ref.watch(runTrackingServiceProvider);
  return service.distanceStream;
});

final runDurationProvider = StreamProvider<int>((ref) {
  final service = ref.watch(runTrackingServiceProvider);
  return service.durationStream;
});

final runPaceProvider = StreamProvider<double>((ref) {
  final service = ref.watch(runTrackingServiceProvider);
  return service.paceStream;
});

final runHistoryProvider = FutureProvider<List<RunRecord>>((ref) async {
  return DatabaseService.getRecentRuns();
});

final todayRunCaloriesProvider = FutureProvider<double>((ref) async {
  final today = ref.watch(todayStringProvider);
  return DatabaseService.getTotalCaloriesBurnedFromRuns(today);
});
