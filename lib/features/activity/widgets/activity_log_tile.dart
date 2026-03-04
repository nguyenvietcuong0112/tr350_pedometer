import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/models/activity_record.dart';

class ActivityLogTile extends StatelessWidget {
  final ActivityRecord activity;

  const ActivityLogTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final type = activity.type;
    final icon = _getIcon(type);
    final color = _getColor(type);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalize(type.name),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _formatTime(activity.startTime),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${activity.calories.toInt()}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                'Kcal',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(width: 24.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity.distance.toStringAsFixed(1).replaceAll('.', ','),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                'km',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.walking:
        return Icons.directions_walk_rounded;
      case ActivityType.running:
        return Icons.directions_run_rounded;
      case ActivityType.cycling:
        return Icons.directions_bike_rounded;
      case ActivityType.trekking:
        return Icons.landscape_rounded;
    }
  }

  Color _getColor(ActivityType type) {
    switch (type) {
      case ActivityType.walking:
        return const Color(0xFF2ECC71); // Green
      case ActivityType.running:
        return const Color(0xFF3498DB); // Blue
      case ActivityType.cycling:
        return const Color(0xFFF39C12); // Orange
      case ActivityType.trekking:
        return const Color(0xFFE74C3C); // Red
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';
  }
}
