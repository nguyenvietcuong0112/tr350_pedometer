import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/step_service.dart';
import '../services/database_service.dart';
import '../models/step_record.dart';
import 'profile_provider.dart';

final stepServiceProvider = Provider<StepService>((ref) {
  final service = StepService();
  ref.onDispose(() => service.dispose());
  return service;
});

final currentStepsProvider = StreamProvider<int>((ref) {
  final service = ref.watch(stepServiceProvider);
  service.startListening();
  return service.stepStream;
});

final todayStepsProvider = FutureProvider<int>((ref) async {
  final today = ref.watch(todayStringProvider);
  final record = await DatabaseService.getStepRecord(today);
  return record?.stepCount ?? 0;
});

final weeklyStepsProvider = FutureProvider<List<StepRecord>>((ref) async {
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 6));
  final from = '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';
  final to = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return DatabaseService.getStepRecords(from, to);
});

final stepCaloriesProvider = Provider<double>((ref) {
  final steps = ref.watch(currentStepsProvider).valueOrNull ?? 0;
  final profile = ref.watch(profileProvider).valueOrNull;
  final weight = profile?.weight ?? 70.0;
  return steps * 0.04 * weight / 70.0;
});
