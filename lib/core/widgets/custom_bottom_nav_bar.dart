import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0.h + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        top: 12.0.h,
        bottom: MediaQuery.of(context).padding.bottom + 8.0.h,
        left: 16.0.w,
        right: 16.0.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            index: 0,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: null, // Replace with 'assets/icons/activities.svg'
            iconData: Icons.pets_rounded,
            label: 'Activities',
          ),
          _NavBarItem(
            index: 1,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: null, // Replace with 'assets/icons/meals.svg'
            iconData: Icons.restaurant_rounded,
            label: 'Meals',
          ),
          _NavBarItem(
            index: 2,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: null, // Replace with 'assets/icons/calories.svg'
            iconData: Icons.local_fire_department_rounded,
            label: 'Calories',
          ),
          _NavBarItem(
            index: 3,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: null, // Replace with 'assets/icons/profile.svg'
            iconData: Icons.assignment_ind_rounded,
            label: 'You',
          ),
          _NavBarItem(
            index: 4,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: null, // Replace with 'assets/icons/settings.svg'
            iconData: Icons.settings_rounded,
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final Function(int) onSelected;
  final String? iconPath;
  final IconData iconData;
  final String label;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.onSelected,
    this.iconPath,
    required this.iconData,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final activeColor = const Color(0xFF1E88E5);
    final inactiveColor = Colors.grey.shade400;

    return GestureDetector(
      onTap: () => onSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 6.0.h),
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20.0.w),
            ),
            child: iconPath != null
                ? SvgPicture.asset(
                    iconPath!,
                    width: 22.0.w,
                    height: 22.0.w,
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    iconData,
                    size: 22.0.w,
                    color: isSelected ? Colors.white : inactiveColor,
                  ),
          ),
          SizedBox(height: 4.0.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
