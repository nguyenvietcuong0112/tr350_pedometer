import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/models/meal_record.dart';
import '../../../core/providers/nutrition_provider.dart';
import '../../../core/services/food_service.dart';
import '../../../core/theme/app_colors.dart';

class GramEditModal extends ConsumerStatefulWidget {
  final MealRecord meal;

  const GramEditModal({super.key, required this.meal});

  @override
  ConsumerState<GramEditModal> createState() => _GramEditModalState();
}

class _GramEditModalState extends ConsumerState<GramEditModal> {
  late TextEditingController _controller;
  double _currentWeight = 0;
  int _calculatedCalories = 0;
  late FoodItem? _sourceFood;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.meal.weightGrams;
    _calculatedCalories = widget.meal.calories;
    _controller = TextEditingController(text: _currentWeight.toInt().toString());
    
    // Find source food to get caloriesPer100g
    _sourceFood = MockFoodDatabase.foods.where((f) => f.name == widget.meal.name).firstOrNull;
  }

  void _updateCalories(String value) {
    if (_sourceFood == null) return;
    
    final newWeight = double.tryParse(value) ?? 0;
    setState(() {
      _currentWeight = newWeight;
      _calculatedCalories = ((_sourceFood!.caloriesPer100g / 100) * newWeight).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0.w, 24.0.h, 24.0.w, MediaQuery.of(context).viewInsets.bottom + 24.0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40.0.w,
              height: 4.0.h,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.0.w),
              ),
            ),
          ),
          SizedBox(height: 24.0.h),
          
          // Header
          Row(
            children: [
              Container(
                width: 60.0.w,
                height: 60.0.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(16.0.w),
                  image: widget.meal.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.meal.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.meal.imageUrl == null
                    ? Icon(Icons.restaurant_rounded, color: Colors.grey, size: 28.0.w)
                    : null,
              ),
              SizedBox(width: 16.0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20.0.sp,
                      ),
                    ),
                    Text(
                      'Edit Gram / Update Food',
                      style: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.8),
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32.0.h),
          
          // Weight Input
          Text(
            'Weight (grams)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.0.h),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: _updateCalories,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0.sp),
            decoration: InputDecoration(
              suffixText: 'g',
              suffixStyle: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
              filled: true,
              fillColor: const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0.w),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            ),
          ),
          SizedBox(height: 24.0.h),
          
          // Calories Recap
          Container(
            padding: EdgeInsets.all(16.0.w),
            decoration: BoxDecoration(
              color: AppColors.activityBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16.0.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Calories',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0.sp,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  '$_calculatedCalories kcal',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0.sp,
                    color: AppColors.activityBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0.h),
          
          // Update Button
          ElevatedButton(
            onPressed: _updateMeal,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.activityBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.w),
              ),
              elevation: 0,
            ),
            child: Text(
              'Update Food',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMeal() async {
    final weight = double.tryParse(_controller.text) ?? 0;
    if (weight <= 0) return;

    await FoodService.updateMealWeight(widget.meal.id, weight, _sourceFood?.caloriesPer100g ?? 0);
    
    ref.invalidate(todayMealsProvider);
    ref.invalidate(todayCaloriesConsumedProvider);
    
    if (mounted) Navigator.pop(context);
  }
}
