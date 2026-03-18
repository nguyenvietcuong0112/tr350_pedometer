import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/models/user_profile.dart';
import 'widgets/profile_edit_modal.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Removed manual TabController to use DefaultTabController instead.

  // Lifecycle methods for manual TabController removed.

  double _calculateBMI(double weight, double heightCm) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16) return 'Underweight (Severe)';
    if (bmi < 17) return 'Underweight (Moderate)';
    if (bmi < 18.5) return 'Underweight (Mild)';
    if (bmi < 23) return 'Normal';
    if (bmi < 25) return 'Overweight';
    if (bmi < 30) return 'Obese (Class I)';
    return 'Obese (Class II)';
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'You',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0.sp,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: profileAsync.when(
          data: (profile) => _buildContent(profile),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildContent(UserProfile profile) {
    final bmi = _calculateBMI(profile.weight, profile.height);
    final category = _getBMICategory(bmi);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.h),
      children: [
        // Profile Card
        _ProfileHeaderCard(profile: profile),
        SizedBox(height: 10.0.h),

        // BMI Card
        _BMICard(bmi: bmi.round(), category: category),
        SizedBox(height: 10.0.h),

        // Goal Section
        Text(
          'Goal',
          style: TextStyle(
            fontSize: 18.0.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 5.0.h),

        // Custom Tab Bar
        Container(
          padding: EdgeInsets.all(4.0.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Light grey-blue background
            borderRadius: BorderRadius.circular(16.0.w),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0.w),
              color: const Color(0xFF3B82F6), // Blue
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15.0.sp,
            ),
            unselectedLabelColor: const Color(0xFF94A3B8),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15.0.sp,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets_rounded, size: 18.0.sp),
                    SizedBox(width: 8.0.w),
                    const Text('Steps'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 18.0.sp),
                    SizedBox(width: 8.0.w),
                    const Text('Calories In'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0.h),

        // Weekly List (Hardcoded to match image for now)
        _WeeklyGoalList(isSteps: true, goalValue: profile.stepGoal.toString()),
      ],
    );
  }
}

class _ProfileHeaderCard extends ConsumerWidget {
  final UserProfile profile;

  const _ProfileHeaderCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(20.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Light grey background
        borderRadius: BorderRadius.circular(24.0.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            padding: EdgeInsets.all(12.0.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              profile.gender == 'male'
                  ? Icons.male_rounded
                  : Icons.female_rounded,
              color: const Color(0xFF3B82F6),
              size: 32.0.w,
            ),
          ),
          SizedBox(width: 20.0.w),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Name, Age, Height
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      profile.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.5.w,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${profile.age} ',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'yrs  ',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${profile.height.toInt()} ',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'cm',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0.h),
                // Bottom Row: Weight Stepper and Edit
                Row(
                  children: [
                    _StepperButton(
                      icon: Icons.remove,
                      onTap: () {
                        ref
                            .read(profileProvider.notifier)
                            .updateWeight(profile.weight - 1);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${profile.weight.toInt()} ',
                              style: TextStyle(
                                color: const Color(0xFF3B82F6),
                                fontSize: 24.0.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'Kg',
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _StepperButton(
                      icon: Icons.add,
                      onTap: () {
                        ref
                            .read(profileProvider.notifier)
                            .updateWeight(profile.weight + 1);
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              ProfileEditModal(profile: profile),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8F0)), // Subtle border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4.0.w,
              offset: Offset(0, 2.0.h),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF3B82F6), size: 18.0.w),
      ),
    );
  }
}

class _BMICard extends StatelessWidget {
  final int bmi;
  final String category;

  const _BMICard({required this.bmi, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark Navy
        borderRadius: BorderRadius.circular(24.0.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Your BMI ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    ' $bmi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 8.0.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B), // Dark green
                  borderRadius: BorderRadius.circular(20.0.w),
                  border: Border.all(
                    color: const Color(0xFF065F46).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: const Color(0xFF34D399), // Emerald
                    fontWeight: FontWeight.w900,
                    fontSize: 14.0.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0.h),
          Text(
            'BEST - LOWEST RISK OF DISEASE',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0.w,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyGoalList extends StatelessWidget {
  final bool isSteps;
  final String goalValue;

  const _WeeklyGoalList({required this.isSteps, required this.goalValue});

  @override
  Widget build(BuildContext context) {
    final days = [
      {'day': 'Monday', 'short': 'M'},
      {'day': 'Wednesday', 'short': 'W'},
      {'day': 'Thursday', 'short': 'T'},
      {'day': 'Friday', 'short': 'F'},
      {'day': 'Saturday', 'short': 'S'},
      {'day': 'Sunday', 'short': 'S'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0.w),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5.w),
      ),
      child: Column(
        children: days.map((day) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: (day['day'] as String)[0],
                        style: TextStyle(
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0.sp,
                        ),
                      ),
                      TextSpan(
                        text: (day['day'] as String).substring(1),
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0.w,
                    vertical: 5.0.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10.0.w),
                  ),
                  child: Text(
                    goalValue,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
