import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';

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
      padding: EdgeInsets.fromLTRB(20.0.w, 8.0.h, 20.0.w, 16.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.0.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text('🥇', style: TextStyle(fontSize: 22.0.sp)),
          ),
          SizedBox(width: 12.0.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  height: 1.5,
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'You have '),
                  TextSpan(
                    text: '$remainingCalories',
                    style: const TextStyle(
                      color: Color(0xFF15A9FA),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ' calories left to reach your '),
                  TextSpan(
                    text: '$goalCalories',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
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
