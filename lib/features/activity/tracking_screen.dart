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
    Future.microtask(
      () => ref.read(trackingServiceProvider(widget.type)).start(),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : (_currentMapType == MapType.satellite
                ? MapType.terrain
                : MapType.normal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(trackingStateProvider(widget.type)).valueOrNull ??
        TrackingState.idle;
    final metrics = ref.watch(trackingMetricsProvider(widget.type)).valueOrNull;
    final route =
        ref.watch(trackingRouteProvider(widget.type)).valueOrNull ?? [];

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
          CameraUpdate.newLatLng(
            LatLng(route.last.latitude, route.last.longitude),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: AppColors.textPrimaryLight,
            size: 24.0.w,
          ),
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
              child: const Icon(
                Icons.layers_rounded,
                color: AppColors.accentBlue,
              ),
            ),
          ),

          // Bottom Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0.w, 12.0.h, 20.0.w, 16.0.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.0.w),
                ),
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
                  // Distance Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5.0.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.0.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          metrics?.distanceKm.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E293B),
                            fontSize: 32.0.sp,
                          ),
                        ),
                        SizedBox(width: 8.0.w),
                        Text(
                          'Km',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0.h),

                  // Secondary Metrics Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.0.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                color: const Color(0xFF0369A1),
                                size: 24.0.w,
                              ),
                              SizedBox(width: 10.0.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    metrics?.formattedTime ?? '00:00:00',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.0.sp,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    'Min',
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.0.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: const Color(0xFFF97316),
                                size: 24.0.w,
                              ),
                              SizedBox(width: 10.0.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${metrics?.calories.toInt() ?? 0}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.0.sp,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    'Kcal',
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0.h),
                  // Control Buttons
                  if (state == TrackingState.active)
                    SizedBox(
                      width: double.infinity,
                      height: 20.0.h,
                      child: ElevatedButton(
                        onPressed: () => ref
                            .read(trackingServiceProvider(widget.type))
                            .pause(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: const Color(0xFF15A9FA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0.w),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.0.w),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.pause_rounded,
                                size: 14.0.w,
                                color: const Color(0xFF15A9FA),
                              ),
                            ),
                            SizedBox(width: 8.0.w),
                            Text(
                              'Pause',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 20.0.h,
                            child: ElevatedButton(
                              onPressed: () => ref
                                  .read(trackingServiceProvider(widget.type))
                                  .resume(),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: const Color(0xFF15A9FA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0.w),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2.0.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      size: 14.0.w,
                                      color: const Color(0xFF15A9FA),
                                    ),
                                  ),
                                  SizedBox(width: 6.0.w),
                                  Text(
                                    'Pause',
                                    style: TextStyle(
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0.w),
                        Expanded(
                          child: SizedBox(
                            height: 20.0.h,
                            child: OutlinedButton(
                              onPressed: () => _handleStop(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: const BorderSide(
                                  color: Color(0xFF15A9FA),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0.w),
                                ),
                                foregroundColor: const Color(0xFF15A9FA),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    size: 16.0.w,
                                    color: const Color(0xFFF97316),
                                  ),
                                  SizedBox(width: 6.0.w),
                                  Text(
                                    'Finish',
                                    style: TextStyle(
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
