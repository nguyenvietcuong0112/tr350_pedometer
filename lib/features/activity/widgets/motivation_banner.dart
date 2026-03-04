import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/theme/app_colors.dart';

class MotivationBanner extends StatelessWidget {
  final int remainingCalories;
  final int goalCalories;

  const MotivationBanner({
    super.key,
    required this.remainingCalories,
    required this.goalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medal Icon (using Emoji/Icon for simplicity, could be Image)
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text('🥇', style: TextStyle(fontSize: 24.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      height: 1.4,
                      fontSize: 14.sp,
                    ),
                children: [
                  const TextSpan(text: 'You have '),
                  TextSpan(
                    text: '$remainingCalories',
                    style: TextStyle(
                      color: AppColors.accentBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  const TextSpan(text: ' calories left to reach your '),
                  TextSpan(
                    text: '$goalCalories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  const TextSpan(text: ' calorie goal for today, keep going!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
