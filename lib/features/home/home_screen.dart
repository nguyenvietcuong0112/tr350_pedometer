import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/providers/dashboard_provider.dart';
import '../../core/providers/step_provider.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/step_progress_ring.dart';
import 'widgets/calorie_summary_card.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/daily_summary_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  bool _goalCelebrated = false;
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Celebrate when goal reached
    final stepProgress = dashboard.stepGoal > 0
        ? dashboard.todaySteps / dashboard.stepGoal
        : 0.0;
    if (stepProgress >= 1.0 && !_goalCelebrated) {
      _goalCelebrated = true;
      Future.microtask(() => _confettiController.play());
    }

    return Stack(
      children: [
        SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good ${_getGreeting()}! 💪',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getMotivation(stepProgress),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Step Progress Ring
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: StepProgressRing(
                      steps: dashboard.todaySteps,
                      goal: dashboard.stepGoal,
                    ),
                  ),
                ),
                // Calorie Cards Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CalorieSummaryCard(
                            title: 'Burned',
                            value: dashboard.caloriesBurned.toInt(),
                            icon: Icons.local_fire_department_rounded,
                            gradient: AppColors.calorieGradient,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CalorieSummaryCard(
                            title: 'Consumed',
                            value: dashboard.caloriesConsumed,
                            icon: Icons.restaurant_rounded,
                            gradient: AppColors.blueGradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Daily Summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: DailySummaryCard(
                      netCalories: dashboard.netCalories,
                      currentWeight: dashboard.currentWeight,
                      targetWeight: dashboard.targetWeight,
                      goalProgress: dashboard.goalProgress,
                    ),
                  ),
                ),
                // Weekly Chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: WeeklyChart(
                      weeklySteps: ref.watch(weeklyStepsProvider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            maxBlastForce: 30,
            minBlastForce: 10,
            emissionFrequency: 0.06,
            numberOfParticles: 25,
            gravity: 0.2,
            colors: const [
              AppColors.primaryGreen,
              AppColors.accentOrange,
              AppColors.accentBlue,
              AppColors.accentPurple,
            ],
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String _getMotivation(double progress) {
    if (progress >= 1.0) return '🎉 Goal reached! Amazing work!';
    if (progress >= 0.75) return 'Almost there! Keep pushing!';
    if (progress >= 0.5) return 'Halfway done! Great progress!';
    if (progress >= 0.25) return 'Nice start! Keep moving!';
    return "Let's get moving today!";
  }
}
