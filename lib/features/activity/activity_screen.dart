import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/activity_provider.dart';
import '../../core/providers/step_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/activity_log_tile.dart';
import 'widgets/activity_type_sheet.dart';
import 'widgets/steps_progress_card.dart';
import 'widgets/activity_stat_cards.dart';
import 'widgets/motivation_banner.dart';
import 'tracking_screen.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final dateLabel = ref.watch(dateDisplayLabelProvider);
    final activitiesAsync = ref.watch(activitiesByDateProvider);
    final statsAsync = ref.watch(dailyActivityStatsProvider);
    
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year && 
                    selectedDate.month == now.month && 
                    selectedDate.day == now.day;
                    
    final steps = isToday 
        ? ref.watch(currentStepsProvider).valueOrNull ?? 0
        : ref.watch(todayStepsProvider).valueOrNull ?? 0;
        
    final profile = ref.watch(profileProvider).valueOrNull;
    final stepGoal = profile?.stepGoal ?? 8000;
    final calorieGoal = profile?.dailyCalorieTarget ?? 1000;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Pedometer',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _DateNavigator(
            label: dateLabel,
            onPrev: () {
              ref.read(selectedDateProvider.notifier).state = 
                  selectedDate.subtract(const Duration(days: 1));
            },
            onNext: () {
              ref.read(selectedDateProvider.notifier).state = 
                  selectedDate.add(const Duration(days: 1));
            },
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                children: [
                  StepsProgressCard(
                    steps: steps,
                    goal: stepGoal,
                    onStartTracking: () => _showActivitySelection(context, ref),
                  ),
                  
                  statsAsync.when(
                    data: (stats) => ActivityStatCards(
                      calories: stats.totalCalories,
                      duration: stats.totalDuration,
                      distance: stats.totalDistance,
                    ),
                    loading: () => const ActivityStatCards(calories: 0, duration: 0, distance: 0),
                    error: (_, __) => const ActivityStatCards(calories: 0, duration: 0, distance: 0),
                  ),
                  
                  statsAsync.when(
                    data: (stats) => MotivationBanner(
                      remainingCalories: (calorieGoal - stats.totalCalories).toInt().clamp(0, calorieGoal),
                      goalCalories: calorieGoal,
                    ),
                    loading: () => MotivationBanner(remainingCalories: calorieGoal, goalCalories: calorieGoal),
                    error: (_, __) => MotivationBanner(remainingCalories: 0, goalCalories: 0),
                  ),
                  
                  const SizedBox(height: 16),
                  SizedBox(height: 16.h),
                  
                  activitiesAsync.when(
                    data: (activities) {
                      if (activities.isEmpty) return const SizedBox.shrink();
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.w),
                          border: Border.all(color: const Color(0xFFF5F5F5), width: 1.h),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
                          separatorBuilder: (context, index) => Divider(height: 1.h, color: const Color(0xFFF5F5F5)),
                          itemBuilder: (context, index) => ActivityLogTile(activity: activities[index]),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('Error loading activities')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActivitySelection(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ActivityTypeSheet(
        onStart: (type) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackingScreen(type: type),
            ),
          ).then((_) {
            ref.invalidate(activitiesByDateProvider);
            ref.invalidate(dailyActivityStatsProvider);
          });
        },
      ),
    );
  }
}


class _DateNavigator extends StatelessWidget {
  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _DateNavigator({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: const Color(0xFFF7F8FA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            icon: Icons.chevron_left_rounded,
            onTap: onPrev,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C5282),
            ),
          ),
          _NavButton(
            icon: Icons.chevron_right_rounded,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.activityBlue,
      borderRadius: BorderRadius.circular(6.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.w),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Icon(icon, color: Colors.white, size: 24.w),
        ),
      ),
    );
  }
}

