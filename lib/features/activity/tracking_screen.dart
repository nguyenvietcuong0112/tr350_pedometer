import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_size/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/models/activity_record.dart';
import '../../core/providers/tracking_provider.dart';
import '../../core/services/activity_tracking_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/activity_provider.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  final ActivityType type;

  const TrackingScreen({super.key, required this.type});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  GoogleMapController? _mapController;
  MapType _currentMapType = MapType.normal;
  final Set<Polyline> _polylines = {};
  
  @override
  void initState() {
    super.initState();
    // Auto-start tracking when screen opens
    Future.microtask(() => ref.read(trackingServiceProvider(widget.type)).start());
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal 
          ? MapType.satellite 
          : (_currentMapType == MapType.satellite ? MapType.terrain : MapType.normal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trackingStateProvider(widget.type)).valueOrNull ?? TrackingState.idle;
    final metrics = ref.watch(trackingMetricsProvider(widget.type)).valueOrNull;
    final route = ref.watch(trackingRouteProvider(widget.type)).valueOrNull ?? [];

    // Update polylines
    if (route.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: route.map((p) => LatLng(p.latitude, p.longitude)).toList(),
          color: const Color(0xFFF39C12), // Orange from reference
          width: 5,
        ),
      );
      
      // Keep camera centered on last point
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(route.last.latitude, route.last.longitude)),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: AppColors.textPrimaryLight, size: 24.0.w),
          onPressed: () => _handleStop(context),
        ),
        title: Text(
          widget.type.displayName,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w900,
            fontSize: 20.0.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.762622, 106.660172), // Default city center
              zoom: 16,
            ),
            mapType: _currentMapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: _polylines,
          ),
          
          // Map Type Toggle Button
          Positioned(
            top: 20.0.h,
            right: 20.0.w,
            child: FloatingActionButton.small(
              onPressed: _toggleMapType,
              backgroundColor: Colors.white,
              child: const Icon(Icons.layers_rounded, color: AppColors.accentBlue),
            ),
          ),
          
          // Bottom Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0.w, 24.0.h, 20.0.w, 30.0.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.w)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0.w,
                    offset: Offset(0, -5.0.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary Metric (Km)
                  Text(
                    metrics?.distanceKm.toStringAsFixed(1) ?? '0,0',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimaryLight,
                          fontSize: 45.0.sp, // Explicit size for responsiveness
                        ),
                  ),
                  Text(
                    'Km',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16.0.sp,
                        ),
                  ),
                  SizedBox(height: 24.0.h),
                  
                  // Secondary Metrics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MetricItem(
                        icon: Icons.directions_walk_rounded,
                        label: 'Steps',
                        value: '${metrics?.steps ?? 0}',
                      ),
                      _MetricItem(
                        icon: Icons.access_time_filled_rounded,
                        label: 'Min',
                        value: metrics?.formattedTime ?? '00:00:00',
                      ),
                      _MetricItem(
                        icon: Icons.local_fire_department_rounded,
                        label: 'Kcal',
                        value: '${metrics?.calories.toInt() ?? 0}',
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0.h),
                  
                  // Control Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56.0.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (state == TrackingState.active) {
                          ref.read(trackingServiceProvider(widget.type)).pause();
                        } else {
                          ref.read(trackingServiceProvider(widget.type)).resume();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0.w)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state == TrackingState.active ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 24.0.w,
                          ),
                          SizedBox(width: 8.0.w),
                          Text(
                            state == TrackingState.active ? 'Pause' : 'Resume',
                            style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStop(BuildContext context) async {
    final service = ref.read(trackingServiceProvider(widget.type));
    final result = await service.stop();
    if (result != null) {
      ref.invalidate(activitiesByDateProvider);
      ref.invalidate(dailyActivityStatsProvider);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 24.0.w),
            SizedBox(width: 8.0.w),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18.0.sp,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 13.0.sp),
        ),
      ],
    );
  }
}
