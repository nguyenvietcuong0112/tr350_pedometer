import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../features/activity/activity_screen.dart';
import '../../features/nutrition/nutrition_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/calories/calories_screen.dart';
import '../../features/settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ActivityScreen(),
    NutritionScreen(),
    CaloriesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.white,
        elevation: 10,
        height: 70.h,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.pets_rounded, color: Colors.grey, size: 24.w),
            selectedIcon: Icon(Icons.pets_rounded, color: const Color(0xFF4B9EF3), size: 24.w),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_rounded, color: Colors.grey, size: 24.w),
            selectedIcon: Icon(Icons.restaurant_rounded, color: const Color(0xFF3498DB), size: 24.w),
            label: 'Meals',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_rounded, color: Colors.grey, size: 24.w),
            selectedIcon: Icon(Icons.local_fire_department_rounded, color: const Color(0xFF3498DB), size: 24.w),
            label: 'Calories',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_ind_rounded, color: Colors.grey, size: 24.w),
            selectedIcon: Icon(Icons.assignment_ind_rounded, color: const Color(0xFF3498DB), size: 24.w),
            label: 'You',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded, color: Colors.grey, size: 24.w),
            selectedIcon: Icon(Icons.settings_rounded, color: const Color(0xFF3498DB), size: 24.w),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
