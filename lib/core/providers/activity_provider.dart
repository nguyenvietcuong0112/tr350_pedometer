import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../models/activity_record.dart';

// Current selected date for activity screen
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Formatted string of selected date
final selectedDateStringProvider = Provider<String>((ref) {
  final date = ref.watch(selectedDateProvider);
  return DateFormat('yyyy-MM-dd').format(date);
});

// Display label for selected date (Today, Yesterday, or Date)
final dateDisplayLabelProvider = Provider<String>((ref) {
  final selected = ref.watch(selectedDateProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(selected.year, selected.month, selected.day);

  if (target == today) return 'Today';
  if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
  return DateFormat('MMMM dd, yyyy').format(selected);
});

// Fetch activities for selected date
final activitiesByDateProvider = FutureProvider<List<ActivityRecord>>((ref) async {
  final dateStr = ref.watch(selectedDateStringProvider);
  return DatabaseService.getActivitiesByDate(dateStr);
});

// Aggregated stats for the selected date
class ActivityStats {
  final double totalCalories;
  final int totalDuration; // seconds
  final double totalDistance;

  ActivityStats({
    this.totalCalories = 0,
    this.totalDuration = 0,
    this.totalDistance = 0,
  });
}

final dailyActivityStatsProvider = FutureProvider<ActivityStats>((ref) async {
  final dateStr = ref.watch(selectedDateStringProvider);
  
  final kcal = await DatabaseService.getTotalActivityCalories(dateStr);
  final duration = await DatabaseService.getTotalActivityDuration(dateStr);
  final distance = await DatabaseService.getTotalActivityDistance(dateStr);
  
  return ActivityStats(
    totalCalories: kcal,
    totalDuration: duration,
    totalDistance: distance,
  );
});
