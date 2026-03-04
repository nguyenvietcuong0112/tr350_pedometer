import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_record.dart';
import '../services/database_service.dart';
import 'profile_provider.dart';

final todayMealsProvider = FutureProvider<List<MealRecord>>((ref) async {
  final today = ref.watch(todayStringProvider);
  return DatabaseService.getMealsByDate(today);
});

final todayCaloriesConsumedProvider = FutureProvider<int>((ref) async {
  final today = ref.watch(todayStringProvider);
  return DatabaseService.getTotalCaloriesConsumed(today);
});

final macroBreakdownProvider = FutureProvider<Map<String, double>>((ref) async {
  final today = ref.watch(todayStringProvider);
  final meals = await DatabaseService.getMealsByDate(today);
  double protein = 0, carbs = 0, fat = 0;
  for (final meal in meals) {
    protein += meal.protein;
    carbs += meal.carbs;
    fat += meal.fat;
  }
  return {'protein': protein, 'carbs': carbs, 'fat': fat};
});

final selectedMealTypeProvider = StateProvider<String>((ref) => 'Breakfast');

final calorieGoalProvider = Provider<int>((ref) {
  final profile = ref.watch(profileProvider).valueOrNull;
  return profile?.dailyCalorieTarget ?? 2500;
});

final mealsByTypeProvider = Provider.family<List<MealRecord>, String>((ref, type) {
  final meals = ref.watch(todayMealsProvider).valueOrNull ?? [];
  return meals.where((m) => m.mealType == type).toList();
});

final activeMealsProvider = Provider<List<MealRecord>>((ref) {
  final type = ref.watch(selectedMealTypeProvider);
  return ref.watch(mealsByTypeProvider(type));
});

