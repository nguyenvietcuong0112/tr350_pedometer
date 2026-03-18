import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/meal_record.dart';

class FoodLogItem extends StatelessWidget {
  final MealRecord meal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FoodLogItem({
    super.key,
    required this.meal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0.h),
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.0.w,
            offset: Offset(0, 4.0.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food Image
          Container(
            width: 50.0.w,
            height: 50.0.w,
            decoration: BoxDecoration(
              color: AppColors.activityGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.0.w),
              image: meal.imageUrl != null
                  ? DecorationImage(
                      image: meal.imageUrl!.startsWith('assets/')
                          ? AssetImage(meal.imageUrl!) as ImageProvider
                          : NetworkImage(meal.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: meal.imageUrl == null
                ? Icon(
                    Icons.restaurant_rounded,
                    color: Colors.grey,
                    size: 24.0.w,
                  )
                : null,
          ),
          SizedBox(width: 12.0.w),
          // Name and Gram Selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.0.h),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0.w,
                      vertical: 4.0.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.activityGrey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${meal.weightGrams.toInt()} g',
                          style: TextStyle(
                            color: AppColors.activityBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0.sp,
                          ),
                        ),
                        SizedBox(width: 4.0.w),
                        Icon(
                          Icons.edit_rounded,
                          size: 14.0.w,
                          color: AppColors.activityBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Calories and Delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.calories} kcal',
                style: TextStyle(
                  color: AppColors.activityBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0.sp,
                ),
              ),
              SizedBox(height: 6.0.h),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.accentRed,
                  size: 20.0.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
