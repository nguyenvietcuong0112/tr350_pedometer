import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../core/models/meal_record.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/nutrition_provider.dart';
import '../../core/services/food_service.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Meals',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18.0.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Navigator
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.0.w),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _DateButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () {},
                    ),
                  ),
                ),
                Text(
                  'Today',
                  style: TextStyle(
                    color: const Color(0xFF2C3E50),
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0.sp,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _DateButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0.w),
              children: [
                // Calories Summary Card
                _CaloriesSummaryCard(
                  consumed: consumed,
                  goal: goal,
                  remaining: remaining,
                  isOverGoal: isOverGoal,
                ),
                SizedBox(height: 20.0.h),

                // Meal Tabs
                const _MealTabSelector(),
                SizedBox(height: 24.0.h),

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
        padding: EdgeInsets.all(8.0.w),
        decoration: BoxDecoration(
          color: const Color(0xFF15A9FA),
          borderRadius: BorderRadius.circular(6.0.w),
        ),
        child: Icon(icon, color: Colors.white, size: 24.0.w),
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
      padding: EdgeInsets.all(24.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC), // Very light blue/grey
        borderRadius: BorderRadius.circular(28.0.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Labels Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consumed',
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Goal: ${NumberFormat('#,###').format(goal)}',
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.h),
          // Values Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                NumberFormat('#,###').format(consumed),
                style: TextStyle(
                  color: const Color(0xFF15A9FA),
                  fontSize: 48.0.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              SizedBox(width: 8.0.w),
              Text(
                'kcal',
                style: TextStyle(
                  color: const Color(0xFF15A9FA),
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${NumberFormat('#,###').format(remaining.abs())} ',
                      style: TextStyle(
                        color: isOverGoal
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B),
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: isOverGoal ? 'over' : 'left',
                      style: TextStyle(
                        color: isOverGoal
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B),
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0.h),
          Stack(
            children: [
              Container(
                height: 12.0.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10.0.w),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 12.0.h,
                  decoration: BoxDecoration(
                    color: isOverGoal
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF15A9FA),
                    borderRadius: BorderRadius.circular(10.0.w),
                  ),
                ),
              ),
            ],
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
      {
        'type': 'Breakfast',
        'icon': Icons.wb_sunny_rounded,
        'color': const Color(0xFFFF9F0A),
      },
      {
        'type': 'Lunch',
        'icon': Icons.wb_sunny_outlined,
        'color': const Color(0xFF007AFF),
      },
      {
        'type': 'Dinner',
        'icon': Icons.nightlight_round,
        'color': const Color(0xFF5856D6),
      },
      {
        'type': 'Other',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFFFF3B30),
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.map((tab) {
          final isSelected = tab['type'] == selectedType;
          return GestureDetector(
            onTap: () => ref.read(selectedMealTypeProvider.notifier).state =
                tab['type'] as String,
            child: Container(
              padding: EdgeInsets.only(bottom: 12.0.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? const Color(0xFF15A9FA)
                        : Colors.transparent,
                    width: 2.5.h,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 20.0.w,
                    color: tab['color'] as Color,
                  ),
                  SizedBox(width: 6.0.w),
                  Text(
                    tab['type'] as String,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF15A9FA)
                          : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0.sp,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Calories consumed',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.0.h),
                Text(
                  '0 kCal',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 48.0.h),
        // Illustration placeholder - ideally an asset image
        Opacity(
          opacity: 0.8,
          child: Image.network(
            'https://cdni.iconscout.com/illustration/premium/thumb/diet-planning-illustration-download-in-svg-png-gif-formats--nutritionist-meal-plan-food-healthy-health-care-pack-illustrations-3304562.png',
            height: 200.0.h,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.restaurant_rounded,
              size: 120.0.w,
              color: const Color(0xFFE2E8F0),
            ),
          ),
        ),
        SizedBox(height: 24.0.h),
        Text(
          'Please include it in your meal.',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w500,
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
            _AddFoodButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FoodSelectionScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Calories consumed',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.0.h),
                Text(
                  '$totalInTab kCal',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.0.h),
        ...meals.map(
          (meal) => FoodLogItem(
            meal: meal,
            onEdit: () => _showEditModal(context, ref, meal),
            onDelete: () async {
              await FoodService.deleteMeal(meal.id);
              ref.invalidate(todayMealsProvider);
              ref.invalidate(todayCaloriesConsumedProvider);
            },
          ),
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 12.0.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0.w),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              color: const Color(0xFF15A9FA),
              size: 24.0.w,
            ),
            SizedBox(width: 8.0.w),
            Text(
              'Add Food',
              style: TextStyle(
                color: const Color(0xFF15A9FA),
                fontWeight: FontWeight.w900,
                fontSize: 18.0.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
