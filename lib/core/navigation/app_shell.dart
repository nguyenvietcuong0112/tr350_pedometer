import 'package:flutter/material.dart';
import '../../features/activity/activity_screen.dart';
import '../../features/nutrition/nutrition_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/calories/calories_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';

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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
