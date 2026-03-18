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
      height: 75.0.h + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        top: 10.0.h,
        bottom: MediaQuery.of(context).padding.bottom + 10.0.h,
        left: 12.0.w,
        right: 12.0.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFF1F5F9), width: 1.5.w),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            index: 0,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: 'assets/icons/ic_activity.svg',
            label: 'Activities',
          ),
          _NavBarItem(
            index: 1,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: 'assets/icons/ic_meals.svg',
            label: 'Meals',
          ),
          _NavBarItem(
            index: 2,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: 'assets/icons/ic_calories.svg',
            label: 'Calories',
          ),
          _NavBarItem(
            index: 3,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: 'assets/icons/ic_you.svg',
            label: 'You',
          ),
          _NavBarItem(
            index: 4,
            currentIndex: currentIndex,
            onSelected: onSelected,
            iconPath: 'assets/icons/ic_settings.svg',
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
  final String iconPath;
  final String label;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.onSelected,
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final activeColor = const Color(0xFF15A9FA);
    final inactiveColor = const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () => onSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(22.0.w),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 24.0.w,
              height: 24.0.w,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : inactiveColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 6.0.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
