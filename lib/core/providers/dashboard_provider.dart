import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';
import 'step_provider.dart';
import 'run_provider.dart';
import 'nutrition_provider.dart';

/// Dashboard summary data
class DashboardData {
  final int todaySteps;
  final int stepGoal;
  final double caloriesBurned; // from steps + runs
  final int caloriesConsumed;
  final int netCalories;
  final double currentWeight;
  final double targetWeight;
  final double goalProgress; // 0.0 to 1.0

  const DashboardData({
    this.todaySteps = 0,
    this.stepGoal = 10000,
    this.caloriesBurned = 0,
    this.caloriesConsumed = 0,
    this.netCalories = 0,
    this.currentWeight = 70,
    this.targetWeight = 65,
    this.goalProgress = 0,
  });
}

final dashboardProvider = Provider<DashboardData>((ref) {
  final profile = ref.watch(profileProvider).valueOrNull;
  final steps = ref.watch(currentStepsProvider).valueOrNull ?? 0;
  final stepCals = ref.watch(stepCaloriesProvider);
  final runCals = ref.watch(todayRunCaloriesProvider).valueOrNull ?? 0.0;
  final consumed = ref.watch(todayCaloriesConsumedProvider).valueOrNull ?? 0;

  final totalBurned = stepCals + runCals;
  final net = totalBurned.toInt() - consumed;

  final currentWeight = profile?.weight ?? 70.0;
  final targetWeight = profile?.targetWeight ?? 65.0;
  final weightDiff = (currentWeight - targetWeight).abs();
  final goalProgress = weightDiff > 0 ? (1 - weightDiff / currentWeight).clamp(0.0, 1.0) : 1.0;

  return DashboardData(
    todaySteps: steps,
    stepGoal: profile?.stepGoal ?? 10000,
    caloriesBurned: totalBurned,
    caloriesConsumed: consumed,
    netCalories: net,
    currentWeight: currentWeight,
    targetWeight: targetWeight,
    goalProgress: goalProgress,
  );
});

final themeProvider = StateProvider<bool>((ref) => false); // false = light, true = dark
