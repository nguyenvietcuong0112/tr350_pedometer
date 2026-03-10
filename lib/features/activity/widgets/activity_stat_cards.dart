import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/theme/app_colors.dart';

class ActivityStatCards extends StatelessWidget {
  final double calories;
  final int duration; // seconds
  final double distance;

  const ActivityStatCards({
    super.key,
    required this.calories,
    required this.duration,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Expanded(
            child: _StatCard(
              iconPath: Icons.local_fire_department_rounded,
              label: 'Calories',
              value: calories.toInt().toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              ),
              unit: 'kcal',
              iconColor: AppColors.activityBlue,
            ),
          ),
          SizedBox(width: 12.0.w),
          Expanded(
            child: _StatCard(
              iconPath: Icons.access_time_rounded,
              label: 'Time',
              value: _formatDuration(duration),
              unit: '',
              iconColor: AppColors.activityBlue,
            ),
          ),
          SizedBox(width: 12.0.w),
          Expanded(
            child: _StatCard(
              iconPath: Icons.location_on_rounded,
              label: 'Distance',
              value: distance.toStringAsFixed(1),
              unit: 'km',
              iconColor: AppColors.activityBlue,
            ),
          ),
        ],
      ),
      )
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _StatCard extends StatelessWidget {
  final IconData iconPath;
  final String label;
  final String value;
  final String unit;
  final Color iconColor;

  const _StatCard({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.unit,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0.w),
        border: Border.all(color: const Color(0xFFE3F2FD), width: 1.5.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.0.w,
            offset: Offset(0, 4.0.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconPath, color: iconColor, size: 20.0.w),
              SizedBox(width: 6.0.w),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w900,
                ),
                children: [
                  TextSpan(text: value),
                  if (unit.isNotEmpty) ...[
                    TextSpan(
                      text: ' ',
                      style: TextStyle(fontSize: 18.0.sp),
                    ),
                    TextSpan(
                      text: unit,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
