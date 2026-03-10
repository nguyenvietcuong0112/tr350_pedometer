import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_size/responsive_size.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/theme/app_colors.dart';

class ProfileEditModal extends ConsumerStatefulWidget {
  final UserProfile profile;

  const ProfileEditModal({super.key, required this.profile});

  @override
  ConsumerState<ProfileEditModal> createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends ConsumerState<ProfileEditModal> {
  late String _gender;
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _gender = widget.profile.gender;
    _nameController = TextEditingController(text: widget.profile.name);
    _heightController = TextEditingController(
      text: widget.profile.height.toInt().toString(),
    );
    _weightController = TextEditingController(
      text: widget.profile.weight.toInt().toString(),
    );
    _goalController = TextEditingController(
      text: widget.profile.targetWeight.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0.w),
          topRight: Radius.circular(24.0.w),
        ),
      ),
      padding: EdgeInsets.only(
        top: 12.0.h,
        left: 20.0.w,
        right: 20.0.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.0.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40.0.w,
                height: 4.0.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.0.w),
                ),
              ),
            ),
            SizedBox(height: 32.0.h),

            // Gender Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GenderOption(
                  gender: 'female',
                  isSelected: _gender == 'female',
                  onTap: () => setState(() => _gender = 'female'),
                ),
                const SizedBox(width: 40),
                _GenderOption(
                  gender: 'male',
                  isSelected: _gender == 'male',
                  onTap: () => setState(() => _gender = 'male'),
                ),
              ],
            ),
            SizedBox(height: 32.0.h),

            // Name
            _buildFieldLabel('Name'),
            _buildTextField(_nameController, 'Your name'),
            SizedBox(height: 20.0.h),

            // Height
            _buildFieldLabel('Your Height'),
            _buildNumericField(_heightController, 'Cm'),
            SizedBox(height: 20.0.h),

            // Weight
            _buildFieldLabel('Your Weight'),
            _buildNumericField(_weightController, 'Kg'),
            SizedBox(height: 20.0.h),

            // Weight Goal
            _buildFieldLabel('Your Weight Goal'),
            _buildNumericField(_goalController, 'Kg'),
            SizedBox(height: 24.0.h),

            // Info Text
            Text(
              'Pedometer needs to provide information so that it can uses cientific principles to calculate the distance and calories burned when you runs.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 24.0.h),

            // Save Button
            ElevatedButton(
              onPressed: () async {
                final updated = widget.profile.copyWith(
                  name: _nameController.text,
                  gender: _gender,
                  height:
                      double.tryParse(_heightController.text) ??
                      widget.profile.height,
                  weight:
                      double.tryParse(_weightController.text) ??
                      widget.profile.weight,
                  targetWeight:
                      double.tryParse(_goalController.text) ??
                      widget.profile.targetWeight,
                );
                await ref.read(profileProvider.notifier).updateProfile(updated);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activityBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.w),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF2C3E50),
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8.0.w),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0.w,
            vertical: 14.0.h,
          ),
        ),
      ),
    );
  }

  Widget _buildNumericField(TextEditingController controller, String unit) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8.0.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 14.0.h,
                ),
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0.w),
            child: Row(
              children: [
                Text(
                  unit,
                  style: TextStyle(
                    color: const Color(0xFF2C3E50),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0.sp,
                  ),
                ),
                SizedBox(width: 4.0.w),
                Icon(Icons.arrow_drop_down, color: Colors.orange, size: 24.0.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = gender == 'female' ? Colors.pink : Colors.blue;
    final icon = gender == 'female' ? Icons.female : Icons.male;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70.0.w,
            height: 70.0.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.activityBlue : Colors.grey[200]!,
                width: 2.0.w,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey[300],
                size: 32.0.w,
              ),
            ),
          ),
          SizedBox(height: 8.0.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 6.0.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.activityBlue
                  : const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(4.0.w),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 14.0.w,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                SizedBox(width: 4.0.w),
                Text(
                  gender == 'female' ? 'Female' : 'Male',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
