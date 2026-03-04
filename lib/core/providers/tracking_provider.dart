import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_record.dart';
import '../services/activity_tracking_service.dart';
import '../providers/profile_provider.dart';
import '../models/run_record.dart'; // Reusing LatLngPoint

final trackingServiceProvider = Provider.family<ActivityTrackingService, ActivityType>((ref, type) {
  final profile = ref.watch(profileProvider).valueOrNull;
  final weight = profile?.weight ?? 70.0;
  
  final service = ActivityTrackingService(type: type, userWeight: weight);
  ref.onDispose(() => service.dispose());
  return service;
});

final trackingStateProvider = StreamProvider.family<TrackingState, ActivityType>((ref, type) {
  return ref.watch(trackingServiceProvider(type)).stateStream;
});

final trackingMetricsProvider = StreamProvider.family<TrackingMetrics, ActivityType>((ref, type) {
  return ref.watch(trackingServiceProvider(type)).metricsStream;
});

final trackingRouteProvider = StreamProvider.family<List<LatLngPoint>, ActivityType>((ref, type) {
  return ref.watch(trackingServiceProvider(type)).routeStream;
});
