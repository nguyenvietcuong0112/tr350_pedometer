import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/models/activity_record.dart';
import '../../../core/theme/app_colors.dart';

class ActivityTypeSheet extends StatefulWidget {
  final Function(ActivityType) onStart;

  const ActivityTypeSheet({super.key, required this.onStart});

  @override
  State<ActivityTypeSheet> createState() => _ActivityTypeSheetState();
}

class _ActivityTypeSheetState extends State<ActivityTypeSheet> {
  ActivityType _selectedType = ActivityType.walking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.0.w,
            height: 4.0.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.0.w),
            ),
          ),
          SizedBox(height: 24.0.h),
          // Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 16.0.h,
            crossAxisSpacing: 16.0.w,
            childAspectRatio: 2.2,
            children: ActivityType.values.map((type) {
              final isSelected = _selectedType == type;
              return _TypeButton(
                type: type,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedType = type),
              );
            }).toList(),
          ),
          SizedBox(height: 24.0.h),
          // Start Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onStart(_selectedType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 56.0.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.w),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, size: 28.0.w),
                SizedBox(width: 8.0.w),
                Text(
                  'Start',
                  style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0.h),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final ActivityType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case ActivityType.walking:
        icon = Icons.directions_walk_rounded;
        color = const Color(0xFF2ECC71);
        break;
      case ActivityType.running:
        icon = Icons.directions_run_rounded;
        color = const Color(0xFF3498DB);
        break;
      case ActivityType.cycling:
        icon = Icons.directions_bike_rounded;
        color = const Color(0xFFF39C12);
        break;
      case ActivityType.trekking:
        icon = Icons.landscape_rounded;
        color = const Color(0xFFE74C3C);
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0.w),
      child: Container(
        padding: EdgeInsets.all(12.0.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0.w),
          border: isSelected
              ? Border.all(color: AppColors.accentOrange, width: 2.0.w)
              : Border.all(color: Colors.transparent, width: 2.0.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.0.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.0.w),
            ),
            SizedBox(width: 10.0.w),
            Text(
              type.displayName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0.sp,
                color: isSelected ? AppColors.textPrimaryLight : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
