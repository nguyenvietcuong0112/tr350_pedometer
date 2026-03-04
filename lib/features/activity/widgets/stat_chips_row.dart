import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StatChipsRow extends StatelessWidget {
  final double calories;
  final int duration; // seconds
  final double distance;

  const StatChipsRow({
    super.key,
    required this.calories,
    required this.duration,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.local_fire_department_rounded,
            value: '${calories.toInt()} Kcal',
            color: AppColors.accentOrange,
          ),
          const SizedBox(width: 8),
          _StatChip(
            icon: Icons.timer_rounded,
            value: _formatDuration(duration),
            color: AppColors.accentBlue,
          ),
          const SizedBox(width: 8),
          _StatChip(
            icon: Icons.directions_run_rounded,
            value: '${distance.toStringAsFixed(1).replaceAll('.', ',')} Km',
            color: AppColors.accentBlue,
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                      fontSize: 13,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
