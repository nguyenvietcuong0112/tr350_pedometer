import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/models/activity_record.dart';

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
      padding: EdgeInsets.all(14.0.w),
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
            height: 2.0.h,
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
            mainAxisSpacing: 8.0.h,
            crossAxisSpacing: 12.0.w,
            childAspectRatio: 2.4,
            children: ActivityType.values.map((type) {
              final isSelected = _selectedType == type;
              return _TypeButton(
                type: type,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedType = type),
              );
            }).toList(),
          ),
          SizedBox(height: 10.0.h),
          // Start Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onStart(_selectedType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF15A9FA),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 18.0.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.w),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4.0.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 20.0.w,
                    color: const Color(0xFF15A9FA),
                  ),
                ),
                SizedBox(width: 12.0.w),
                Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w900,
                  ),
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
    Color circleColor;

    switch (type) {
      case ActivityType.walking:
        icon = Icons.directions_walk_rounded;
        circleColor = const Color(0xFF4ADE80);
        break;
      case ActivityType.running:
        icon = Icons.directions_run_rounded;
        circleColor = const Color(0xFF3B82F6);
        break;
      case ActivityType.cycling:
        icon = Icons.directions_bike_rounded;
        circleColor = const Color(0xFFFBBF24);
        break;
      case ActivityType.trekking:
        icon = Icons.landscape_rounded;
        circleColor = const Color(0xFFF87171);
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.0.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 4.0.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.0.w),
          border: Border.all(
            color: isSelected ? const Color(0xFFF97316) : Colors.transparent,
            width: 2.5.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38.0.w,
              height: 38.0.w,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 22.0.w),
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: Text(
                type.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  fontSize: 14.0.sp,
                  color: const Color(0xFF334155),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
