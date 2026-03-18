import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/activity_provider.dart';
import '../../core/providers/step_provider.dart';
import '../../core/providers/profile_provider.dart';
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
    final isToday =
        selectedDate.year == now.year &&
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
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
            fontSize: 18.0.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _DateNavigator(
            label: dateLabel,
            onPrev: () {
              ref.read(selectedDateProvider.notifier).state = selectedDate
                  .subtract(const Duration(days: 1));
            },
            onNext: () {
              ref.read(selectedDateProvider.notifier).state = selectedDate.add(
                const Duration(days: 1),
              );
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0.h),
                  StepsProgressCard(
                    steps: steps,
                    goal: stepGoal,
                    onStartTracking: () => _showActivitySelection(context, ref),
                  ),
                  SizedBox(height: 10.0.h),
                  statsAsync.when(
                    data: (stats) => ActivityStatCards(
                      calories: stats.totalCalories,
                      duration: stats.totalDuration,
                      distance: stats.totalDistance,
                    ),
                    loading: () => const ActivityStatCards(
                      calories: 0,
                      duration: 0,
                      distance: 0,
                    ),
                    error: (_, __) => const ActivityStatCards(
                      calories: 0,
                      duration: 0,
                      distance: 0,
                    ),
                  ),
                  statsAsync.when(
                    data: (stats) => MotivationBanner(
                      remainingCalories: (calorieGoal - stats.totalCalories)
                          .toInt()
                          .clamp(0, calorieGoal),
                      goalCalories: calorieGoal,
                    ),
                    loading: () => MotivationBanner(
                      remainingCalories: calorieGoal,
                      goalCalories: calorieGoal,
                    ),
                    error: (_, __) =>
                        MotivationBanner(remainingCalories: 0, goalCalories: 0),
                  ),
                  SizedBox(height: 16.0.h),
                  activitiesAsync.when(
                    data: (activities) {
                      if (activities.isEmpty) return const SizedBox.shrink();
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0.w),
                          border: Border.all(
                            color: const Color(0xFFF1F5F9),
                            width: 1.5,
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: const Color(0xFFF1F5F9),
                          ),
                          itemBuilder: (context, index) =>
                              ActivityLogTile(activity: activities[index]),
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) =>
                        const Center(child: Text('Error loading activities')),
                  ),
                  SizedBox(height: 24.0.h),
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
            MaterialPageRoute(builder: (context) => TrackingScreen(type: type)),
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
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 12.0.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrev),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
          _NavButton(
            icon: Icons.play_arrow_rounded, // Matches the image's right arrow
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.0.w,
        height: 36.0.w,
        decoration: BoxDecoration(
          color: const Color(0xFF15A9FA),
          borderRadius: BorderRadius.circular(6.0.w),
        ),
        child: Icon(icon, color: Colors.white, size: 24.0.w),
      ),
    );
  }
}
