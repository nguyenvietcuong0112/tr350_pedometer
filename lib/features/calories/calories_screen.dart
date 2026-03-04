import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_size/responsive_size.dart';
import 'package:intl/intl.dart';
import '../../core/providers/nutrition_provider.dart';
import '../../core/providers/dashboard_provider.dart';
import '../../core/theme/app_colors.dart';

class CaloriesScreen extends ConsumerWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.watch(dashboardProvider);
    final consumed = dashboardData.caloriesConsumed;
    final active = dashboardData.caloriesBurned;
    final goal = ref.watch(calorieGoalProvider);
    
    // Assuming BMR of 1600 for visualization matching the image (Total = Active + BMR)
    const bmr = 1600;
    final totalBurned = active + bmr;
    final net = consumed - totalBurned;
    final isDeficit = net < 0;

    // Intake percentage vs goal (for subtext)
    final intakeVsGoal = goal > 0 ? ((consumed - goal) / goal * 100).round() : 0;
    final intakeLabel = intakeVsGoal >= 0 ? '+$intakeVsGoal% vs Goal' : '$intakeVsGoal% vs Goal';
    final intakeColor = intakeVsGoal > 0 ? AppColors.accentRed : AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Calories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Navigator
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFFF0F0F0), width: 1.h),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DateNavButton(icon: Icons.chevron_left_rounded, onTap: () {}),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: AppColors.activityBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                _DateNavButton(icon: Icons.chevron_right_rounded, onTap: () {}),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                // Summary Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'INTAKE',
                        icon: Icons.restaurant_rounded,
                        value: NumberFormat('#,###').format(consumed),
                        subtext: intakeLabel,
                        subtextColor: intakeColor,
                        valueColor: AppColors.activityOrange,
                        backgroundColor: const Color(0xFFF0F7FF),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _SummaryCard(
                        title: 'BURNED',
                        icon: Icons.local_fire_department_rounded,
                        value: NumberFormat('#,###').format(totalBurned),
                        subtext: 'Active: ${active.toInt()}',
                        subtextColor: AppColors.activityBlue,
                        valueColor: AppColors.primaryGreen,
                        backgroundColor: const Color(0xFFF0FAFF),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                
                // Surplus/Deficit Dark Card
                _NetCalorieCard(
                  netValue: net.toInt(),
                  isDeficit: isDeficit,
                ),
                SizedBox(height: 24.h),
                
                // Walking Burned Info Card
                _InfoCard(
                  icon: Icons.local_fire_department_rounded,
                  text: 'THE NUMBER OF CALORIES BURNED BY WALKING WAS ${active.toInt()} kcal',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DateNavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.activityBlue,
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Icon(icon, color: Colors.white, size: 24.w),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String subtext;
  final Color subtextColor;
  final Color valueColor;
  final Color backgroundColor;

  const _SummaryCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.subtext,
    required this.subtextColor,
    required this.valueColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: AppColors.activityBlue.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.w,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(icon, size: 16.w, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  'kcal',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            subtext,
            style: TextStyle(
              color: subtextColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetCalorieCard extends StatelessWidget {
  final int netValue;
  final bool isDeficit;

  const _NetCalorieCard({
    required this.netValue,
    required this.isDeficit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1221), // Navy dark background
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SURPLUS / DEFICIT',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.w,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${netValue > 0 ? '+' : ''}$netValue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      'kcal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2E2A), // Success dark background
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Text(
              isDeficit ? 'In Deficit' : 'In Surplus',
              style: TextStyle(
                color: const Color(0xFF2ECC71), // Success green
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.activityOrange, size: 24.w),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF7F8C8D),
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                height: 1.4.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
