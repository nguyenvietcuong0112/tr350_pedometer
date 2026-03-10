import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0.sp,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
        children: [
          _SettingsTile(
            icon: Icons.translate_rounded,
            title: 'Language',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.share_outlined,
            title: 'Share app',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.star_outline_rounded,
            title: 'Rate',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.verified_user_outlined,
            title: 'Policy',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(16.0.w),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2C3E50), size: 24.0.w),
            SizedBox(width: 16.0.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.activityBlue,
              size: 24.0.w,
            ),
          ],
        ),
      ),
    );
  }
}
