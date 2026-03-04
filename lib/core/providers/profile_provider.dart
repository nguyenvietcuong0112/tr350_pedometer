import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    return DatabaseService.getUserProfile();
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await DatabaseService.updateUserProfile(profile);
      return profile;
    });
  }

  Future<void> updateWeight(double weight) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(weight: weight);
    await updateProfile(updated);
  }

  Future<void> updateStepGoal(int goal) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(stepGoal: goal);
    await updateProfile(updated);
  }

  Future<void> updateCalorieTarget(int target) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(dailyCalorieTarget: target);
    await updateProfile(updated);
  }
}

final todayStringProvider = Provider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});
