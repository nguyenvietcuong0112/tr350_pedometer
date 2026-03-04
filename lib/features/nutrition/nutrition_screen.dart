import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../core/models/meal_record.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/nutrition_provider.dart';
import '../../core/services/food_service.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/food_log_item.dart';
import 'food_selection_screen.dart';
import 'widgets/gram_edit_modal.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(selectedMealTypeProvider);
    final meals = ref.watch(activeMealsProvider);
    final consumed = ref.watch(todayCaloriesConsumedProvider).valueOrNull ?? 0;
    final goal = ref.watch(calorieGoalProvider);
    final remaining = goal - consumed;
    final isOverGoal = remaining < 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Meals',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Navigator
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DateButton(icon: Icons.chevron_left_rounded, onTap: () {}),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: AppColors.activityBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                _DateButton(icon: Icons.chevron_right_rounded, onTap: () {}),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // Calories Summary Card
                _CaloriesSummaryCard(
                  consumed: consumed,
                  goal: goal,
                  remaining: remaining,
                  isOverGoal: isOverGoal,
                ),
                SizedBox(height: 24.h),

                // Meal Tabs
                const _MealTabSelector(),
                SizedBox(height: 16.h),

                // Content Area (Empty or List)
                if (meals.isEmpty)
                  _EmptyState(mealType: activeTab)
                else
                  _FilledState(
                    meals: meals,
                    totalInTab: meals.fold(0, (sum, m) => sum + m.calories),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DateButton({required this.icon, required this.onTap});

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
        child: Icon(icon, color: Colors.white, size: 20.w),
      ),
    );
  }
}

class _CaloriesSummaryCard extends StatelessWidget {
  final int consumed;
  final int goal;
  final int remaining;
  final bool isOverGoal;

  const _CaloriesSummaryCard({
    required this.consumed,
    required this.goal,
    required this.remaining,
    required this.isOverGoal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / goal).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20.w,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consumed',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat('#,###').format(consumed),
                style: TextStyle(
                  color: AppColors.activityBlue,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'kcal',
                  style: TextStyle(
                    color: AppColors.activityBlue,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Goal: ${NumberFormat('#,###').format(goal)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${NumberFormat('#,###').format(remaining.abs())} ${isOverGoal ? 'over' : 'left'}',
                    style: TextStyle(
                      color: isOverGoal ? AppColors.accentRed : AppColors.activityOrange,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12.h,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverGoal ? AppColors.accentRed : AppColors.activityBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTabSelector extends ConsumerWidget {
  const _MealTabSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedMealTypeProvider);
    final tabs = [
      {'type': 'Breakfast', 'icon': Icons.wb_sunny_outlined},
      {'type': 'Lunch', 'icon': Icons.light_mode_rounded},
      {'type': 'Dinner', 'icon': Icons.dark_mode_outlined},
      {'type': 'Snack', 'icon': Icons.apple_rounded},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab['type'] == selectedType;
          return GestureDetector(
            onTap: () => ref.read(selectedMealTypeProvider.notifier).state = tab['type'] as String,
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.activityBlue : Colors.transparent,
                    width: 2.h,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 20.w,
                    color: isSelected ? AppColors.activityBlue : Colors.grey,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    tab['type'] as String,
                    style: TextStyle(
                      color: isSelected ? AppColors.activityBlue : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String mealType;
  const _EmptyState({required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _AddFoodButton(onTap: () => _openFoodSelection(context)),
            const Spacer(),
            Text(
              'Calories consumed: 0 kCal',
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(height: 40.h),
        Icon(Icons.fastfood_rounded, size: 100.w, color: Colors.grey.withValues(alpha: 0.2)),
        SizedBox(height: 16.h),
        Text(
          'Please include it in your meal.',
          style: TextStyle(color: Colors.grey, fontSize: 15.sp),
        ),
        SizedBox(height: 24.h),
        ElevatedButton.icon(
          onPressed: () => _openFoodSelection(context),
          icon: Icon(Icons.add_rounded, size: 18.w),
          label: Text('Add Food', style: TextStyle(fontSize: 14.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.activityBlue,
            elevation: 0,
            side: BorderSide(color: AppColors.activityBlue, width: 1.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
          ),
        ),
      ],
    );
  }

  void _openFoodSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FoodSelectionScreen()),
    );
  }
}

class _FilledState extends ConsumerWidget {
  final List<MealRecord> meals;
  final int totalInTab;

  const _FilledState({required this.meals, required this.totalInTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            _AddFoodButton(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FoodSelectionScreen()),
              );
            }),
            const Spacer(),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                children: [
                  const TextSpan(text: 'Calories consumed: '),
                  TextSpan(
                    text: '$totalInTab kCal',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...meals.map((meal) => FoodLogItem(
              meal: meal,
              onEdit: () => _showEditModal(context, ref, meal),
              onDelete: () async {
                await FoodService.deleteMeal(meal.id);
                ref.invalidate(todayMealsProvider);
                ref.invalidate(todayCaloriesConsumedProvider);
              },
            )),
      ],
    );
  }

  void _showEditModal(BuildContext context, WidgetRef ref, MealRecord meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GramEditModal(meal: meal),
    );
  }
}

class _AddFoodButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddFoodButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w),
          border: Border.all(color: AppColors.activityBlue.withValues(alpha: 0.1), width: 1.h),
        ),
        child: Row(
          children: [
            Icon(Icons.add_rounded, color: AppColors.activityBlue, size: 20.w),
            SizedBox(width: 4.w),
            Text(
              'Add Food',
              style: TextStyle(
                color: AppColors.activityBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
