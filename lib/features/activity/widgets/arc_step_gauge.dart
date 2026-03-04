import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ArcStepGauge extends StatelessWidget {
  final int steps;
  final int goal;
  final double size;

  const ArcStepGauge({
    super.key,
    required this.steps,
    required this.goal,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (steps / goal).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom Painter for the Arc
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _ArcPainter(
                progress: progress,
                trackColor: isDark ? Colors.white10 : Colors.white24,
                progressGradient: AppColors.primaryGradient, // Using primary green for now, but reference has blue. Let's adjust.
              ),
            ),
          ),
          // Center Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$steps',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.directions_walk_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Daily goal:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              Text(
                '$goal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Gradient progressGradient;

  _ArcPainter({
    required this.progress,
    required this.trackColor,
    required this.progressGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.12;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // We want a ~240 degree sweep symmetric at the top.
    // Start angle: 150 degrees (math.pi * 5/6)
    // Sweep angle: 240 degrees (math.pi * 4/3)
    const startAngle = math.pi * 0.85;
    const sweepAngle = math.pi * 1.3;

    final backgroundPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint = Paint()
      ..shader = progressGradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
