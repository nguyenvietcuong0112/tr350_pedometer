import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';

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
                icon: Icons.local_fire_department_rounded,
                label: 'Calories',
                value: calories.toInt().toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                ),
                unit: 'kcal',
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: _StatCard(
                icon: Icons.access_time_rounded,
                label: 'Time',
                value: _formatDuration(duration),
                unit: '',
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: _StatCard(
                icon: Icons.location_on_rounded,
                label: 'Distance',
                value: distance.toStringAsFixed(1),
                unit: 'km',
              ),
            ),
          ],
        ),
      ),
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
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0.w),
        border: Border.all(color: const Color(0xFFE3F2FD), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF15A9FA), size: 18.0.w),
              SizedBox(width: 4.0.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0.h),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
