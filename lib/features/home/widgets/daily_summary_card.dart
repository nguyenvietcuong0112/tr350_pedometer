import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DailySummaryCard extends StatelessWidget {
  final int netCalories;
  final double currentWeight;
  final double targetWeight;
  final double goalProgress;

  const DailySummaryCard({
    super.key,
    required this.netCalories,
    required this.currentWeight,
    required this.targetWeight,
    required this.goalProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 Daily Summary',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          // Net Calories
          _SummaryRow(
            label: 'Net Calories',
            value: '${netCalories > 0 ? '+' : ''}$netCalories kcal',
            valueColor: netCalories >= 0
                ? AppColors.primaryGreen
                : AppColors.accentRed,
            icon: Icons.balance_rounded,
          ),
          const SizedBox(height: 12),
          // Weight Goal
          _SummaryRow(
            label: 'Weight Goal',
            value:
                '${currentWeight.toStringAsFixed(1)} → ${targetWeight.toStringAsFixed(1)} kg',
            valueColor: AppColors.accentBlue,
            icon: Icons.monitor_weight_rounded,
          ),
          const SizedBox(height: 16),
          // Goal Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goalProgress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: isDark
                  ? AppColors.dividerDark
                  : AppColors.dividerLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Goal Progress: ${(goalProgress * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: valueColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
