import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/theme/app_colors.dart';

class StepsProgressCard extends StatelessWidget {
  final int steps;
  final int goal;
  final VoidCallback onStartTracking;

  const StepsProgressCard({
    super.key,
    required this.steps,
    required this.goal,
    required this.onStartTracking,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (steps / goal).clamp(0.0, 1.0);
    final stepsLeft = (goal - steps).clamp(0, goal);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 1.0.h),
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 12.0.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.activityBlue,
        borderRadius: BorderRadius.circular(28.0.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.activityBlue.withValues(alpha: 0.3),
            blurRadius: 15.0.w,
            offset: Offset(0, 8.0.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon
          Positioned(
            right: -20.0.w,
            bottom: -20.0.h,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.directions_run_rounded,
                size: 140.0.w,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of steps taken today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.0.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$steps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8.0.w),
                  Row(
                    children: [
                      Transform.rotate(
                        angle: -0.2,
                        child: Icon(
                          Icons.pets_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 14.0.w,
                        ),
                      ),
                      SizedBox(width: 4.0.w),
                      Transform.rotate(
                        angle: 0.2,
                        child: Icon(
                          Icons.pets_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 14.0.w,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Goal: ${goal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0.sp,
                        ),
                      ),
                      Text(
                        '$stepsLeft left',
                        style: TextStyle(
                          color: const Color(0xFF00E5FF), // Cyan/Light Green
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.0.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0.w),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6.0.h,
                ),
              ),
              SizedBox(height: 16.0.h),
              Center(
                child: SizedBox(
                  height: 20.0.h,
                  child: ElevatedButton(
                    onPressed: onStartTracking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.activityBlue,
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0.w),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 20.0.w),
                        SizedBox(width: 6.0.w),
                        Text(
                          'Start New Tracking',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
