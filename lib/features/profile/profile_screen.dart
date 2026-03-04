import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/models/user_profile.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/profile_edit_modal.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double _calculateBMI(double weight, double heightCm) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16) return 'Gầy độ III';
    if (bmi < 17) return 'Gầy độ II';
    if (bmi < 18.5) return 'Gầy độ I';
    if (bmi < 23) return 'Bình thường';
    if (bmi < 25) return 'Thừa cân';
    if (bmi < 30) return 'Béo phì độ I';
    return 'Béo phì độ II';
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
            fontSize: 20.sp,
          ),
        ),
      ),
      body: profileAsync.when(
        data: (profile) => _buildContent(profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(UserProfile profile) {
    final bmi = _calculateBMI(profile.weight, profile.height);
    final category = _getBMICategory(bmi);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      children: [
        // Profile Card
        _ProfileHeaderCard(profile: profile),
        SizedBox(height: 20.h),

        // BMI Card
        _BMICard(bmi: bmi.round(), category: category),
        SizedBox(height: 32.h),

        // Goal Section
        Text(
          'Goal',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 16.h),

        // Custom Tab Bar
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1.h),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.activityBlue,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets_rounded, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Calories In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Weekly List (Hardcoded to match image for now)
        _WeeklyGoalList(
          isSteps: true,
          goalValue: profile.stepGoal.toString(),
        ),
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              profile.gender == 'male' ? Icons.male_rounded : Icons.female_rounded,
              color: AppColors.activityBlue,
              size: 32.w,
            ),
          ),
          SizedBox(width: 16.w),
          // Info Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7F8C8D),
                    letterSpacing: 0.5.w,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '${profile.age} ',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                    Text(
                      'yrs  ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${profile.height.toInt()} ',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                    Text(
                      'cm',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Weight Stepper
                Row(
                  children: [
                    _StepperButton(
                      icon: Icons.remove,
                      onTap: () {
                        ref.read(profileProvider.notifier).updateWeight(profile.weight - 1);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${profile.weight.toInt()} ',
                              style: TextStyle(
                                color: AppColors.activityBlue,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'Kg',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
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
                        ref.read(profileProvider.notifier).updateWeight(profile.weight + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ProfileEditModal(profile: profile),
              );
            },
            child: Text(
              'Edit',
              style: TextStyle(
                color: AppColors.activityBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
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
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.w,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.activityBlue, size: 20.w),
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
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1221),
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Your BMI ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$bmi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2E2A),
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: const Color(0xFF2ECC71),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'BEST - LOWEST RISK OF DISEASE',
            style: TextStyle(
              color: const Color(0xFF7F8C8D),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.w,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1.h),
      ),
      child: Column(
        children: days.map((day) {
          final isLast = days.last == day;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: day['short'] as String,
                            style: TextStyle(
                              color: AppColors.activityBlue,
                              fontWeight: FontWeight.w900,
                              fontSize: 18.sp,
                            ),
                          ),
                          TextSpan(
                            text: day['day']!.substring(1),
                            style: TextStyle(
                              color: const Color(0xFF2C3E50),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Text(
                        goalValue,
                        style: TextStyle(
                          color: const Color(0xFF2C3E50),
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 20, endIndent: 20),
            ],
          );
        }).toList(),
      ),
    );
  }
}
