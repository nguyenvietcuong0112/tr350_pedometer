import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 20.0.w),
      padding: EdgeInsets.fromLTRB(24.0.w, 10.0.h, 24.0.w, 10.0.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF15A9FA),
        borderRadius: BorderRadius.circular(28.0.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF15A9FA).withValues(alpha: 0.3),
            blurRadius: 15.0.w,
            offset: Offset(0, 8.0.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon - Subtle Runner
          Positioned(
            right: -20.0.w,
            bottom: -20.0.h,
            child: Opacity(
              opacity: 0.15,
              child: SvgPicture.asset(
                'assets/icons/ic_activity.svg',
                width: 140.0.w,
                height: 140.0.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of steps taken today',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.0.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat('#,###').format(steps),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52.0.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(width: 4.0.w),
                  SvgPicture.asset(
                    'assets/icons/ic_activity.svg',
                    width: 20.0.w,
                    height: 20.0.w,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: 0.8),
                      BlendMode.srcIn,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Goal: ${NumberFormat('#,###').format(goal)}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 15.0.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(stepsLeft)} left',
                        style: TextStyle(
                          color: const Color(0xFF00F2FF),
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0.h),
              // Progress Bar
              Stack(
                children: [
                  Container(
                    height: 10.0.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.0.w),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 10.0.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0.w),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0.h),
              Center(
                child: GestureDetector(
                  onTap: onStartTracking,
                  child: Container(
                    height: 20.0.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: const Color(0xFF15A9FA),
                          size: 24.0.w,
                        ),
                        SizedBox(width: 6.0.w),
                        Text(
                          'Start New Tracking',
                          style: TextStyle(
                            color: const Color(0xFF15A9FA),
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w900,
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
